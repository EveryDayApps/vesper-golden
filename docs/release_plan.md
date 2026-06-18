# Release Runbook — VS Code Theme Extension

A generic, repeatable playbook to release this extension to **VS Code Marketplace** + **Open VSX**.
Any AI agent (or human) can execute it top-to-bottom. Replace `<X.Y.Z>` with the target version.

> Assumptions: this is a VS Code extension repo (`package.json` with `publisher`, `contributes`, `engines.vscode`). Publishing tools `@vscode/vsce` and `ovsx` are devDependencies (or invoked via `npx`).

---

## 0. Choose the version

Follow semver against the **last published** version:
- **patch** (`X.Y.Z+1`): color tweaks, fixes, no setting/label changes.
- **minor** (`X.Y+1.0`): new theme variant or additive features, no breaking changes.
- **major** (`X+1.0.0`): anything that breaks a user's existing config — e.g. renaming a theme `label` (breaks their `workbench.colorTheme` setting), changing the publisher/extension id, raising `engines.vscode` past common installs.

Record the chosen version as `<X.Y.Z>` for all steps below.

---

## 1. Apply file changes

### 1.1 `package.json`
- [ ] Set `"version": "<X.Y.Z>"`.
- [ ] `displayName` / `description` accurate (mention all theme variants).
- [ ] `publisher`, `repository.url`, `homepage`, `bugs.url` point at the **current** GitHub repo.
- [ ] `engines.vscode` set to lowest version you intend to support.
- [ ] Ensure publish scaffolding exists:
  ```json
  "scripts": {
    "package": "vsce package",
    "publish:vsce": "vsce publish",
    "publish:ovsx": "ovsx publish"
  },
  "devDependencies": { "@vscode/vsce": "^3.2.0", "ovsx": "^0.10.0" }
  ```

### 1.2 `CHANGELOG.md`
- [ ] Add a `## [<X.Y.Z>] - <YYYY-MM-DD>` section (today's date).
- [ ] Group notes under `#### Added` / `#### Changed` / `#### Fixed`.
- [ ] **Call out any breaking change explicitly** (e.g. renamed setting values) with migration instructions.

### 1.3 `.vscodeignore` (keep package small)
- [ ] Exclude everything not needed at runtime: `.vscode/**`, `images/**` (if README loads them from raw URLs), `.claude/**`, `docs/**`, `todo.md`, `*.vsix`, `package-lock.json`, `.DS_Store`.

### 1.4 README
- [ ] Theme names / `workbench.colorTheme` examples match the `label`s in `package.json` exactly.
- [ ] Badge + image URLs point at the current repo/publisher.
- [ ] Marketplace `itemName` and Open VSX `namespace/extension` use the **publisher** id (this does NOT change when the GitHub org moves).

### 1.5 Validate
- [ ] All theme JSON files parse: `for f in themes/*.json; do node -e "require('./'+process.argv[1])" "$f"; done` (or `python3 -c "import json;json.load(open('$f'))"`).

---

## 2. Build & verify locally

- [ ] `npm install`
- [ ] `npx vsce package` → produces `<name>-<X.Y.Z>.vsix`. Inspect the printed file list — confirm only intended files are included.
- [ ] `code --install-extension <name>-<X.Y.Z>.vsix --force`
- [ ] In VS Code: `Cmd/Ctrl+K Cmd/Ctrl+T`, switch each theme, eyeball editor / terminal / markdown / git gutter. Reload window if not applied.
- [ ] Delete any stale older `*.vsix`.

---

## 3. Commit, tag, GitHub Release

- [ ] Commit all release changes. (Respect repo commit-message conventions — check recent `git log`.)
- [ ] Push the branch.
- [ ] After it lands on the default branch, tag and push:
  ```
  git tag -a v<X.Y.Z> -m "<name> v<X.Y.Z>"
  git push origin v<X.Y.Z>
  ```
- [ ] Create the GitHub Release (notes = the CHANGELOG section, attach the `.vsix`):
  ```
  gh release create v<X.Y.Z> <name>-<X.Y.Z>.vsix --title "<name> v<X.Y.Z>" --notes "<changelog section>"
  ```

> Order: **verify → commit → publish → tag points at shipped commit**. If you tag before publishing and publish fails, you get a tag on unpublished code.

---

## 4. Publish — VS Code Marketplace

Prereq (one-time): publisher exists; an **Azure DevOps PAT** with scope **Marketplace → Manage** (org = "all accessible organizations").

> SECURITY: never paste the token into a shared transcript. Prefer interactive login or an env var set in the operator's own terminal. If an AI agent is driving, have the human run these.

- [ ] `npx vsce login <publisher>`  (paste PAT at the hidden prompt) — stores creds.
- [ ] `npx vsce publish`  (reads version from `package.json`).
- [ ] Verify: open `https://marketplace.visualstudio.com/items?itemName=<publisher>.<name>`.
  - Note: `vsce show <publisher>.<name>` caches heavily and lags; trust the `DONE Published` message + the live page.

## 5. Publish — Open VSX

Prereq (one-time): account at open-vsx.org (GitHub login); an **Open VSX access token**; verified namespace.

- [ ] If namespace missing: `npx ovsx create-namespace <publisher> -p <OVSX_TOKEN>`
- [ ] `npx ovsx publish <name>-<X.Y.Z>.vsix -p <OVSX_TOKEN>`
- [ ] Open VSX may queue the version **under review** — public API returns 404 until approved (hours–a day). This is normal, not a failure.
- [ ] Verify:
  ```
  curl -s -o /dev/null -w "%{http_code}\n" https://open-vsx.org/api/<publisher>/<name>/<X.Y.Z>   # 200 = live
  ```

---

## 6. Post-release

- [ ] Confirm both listings show `<X.Y.Z>` (allow for index/cache lag + Open VSX review).
- [ ] Smoke-test install from each marketplace in a clean editor (VS Code + VSCodium).
- [ ] README badge counts populate once indexed.
- [ ] Close related issues / announce.

---

## Secrets checklist (gather before §4)
| Secret | Source | Scope |
|---|---|---|
| Azure DevOps PAT | dev.azure.com → User Settings → Personal Access Tokens | Marketplace: Manage |
| Open VSX token | open-vsx.org → profile → Access Tokens | publish |

## Optional: CI automation (future)
GitHub Action on tag push (`v*`): `npm ci` → `vsce package` → `vsce publish` + `ovsx publish` using repo secrets `VSCE_PAT` and `OVSX_PAT`. Removes the manual token handling in §4–5.
