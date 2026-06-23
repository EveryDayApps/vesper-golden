# Release Runbook: Vesper Golden

A repeatable playbook to release each platform. Three independent tracks:

- **Part 1: VS Code** to the **VS Code Marketplace** and **Open VSX**.
- **Part 2: JetBrains** (Android Studio, IntelliJ, and the rest) to the **JetBrains Marketplace**.
- **Part 3: Obsidian** to the **Obsidian community theme gallery**.

The tracks ship on their own versions and schedules; you do not have to release them together. Replace `<X.Y.Z>` with the target version. Any AI agent or human can execute a track top-to-bottom.

---

# Part 1: VS Code

> Assumptions: a VS Code extension repo (`package.json` with `publisher`, `contributes`, `engines.vscode`). Publishing tools `@vscode/vsce` and `ovsx` are devDependencies (or invoked via `npx`).
>
> Working directory: the extension lives under `platforms/vscode/`. Run every command in Part 1 from there (`cd platforms/vscode`), not the repo root.

---

## 0. Choose the version

Follow semver against the **last published** version:
- **patch** (`X.Y.Z+1`): color tweaks, fixes, no setting/label changes.
- **minor** (`X.Y+1.0`): new theme variant or additive features, no breaking changes.
- **major** (`X+1.0.0`): anything that breaks a user's existing config, e.g. renaming a theme `label` (breaks their `workbench.colorTheme` setting), changing the publisher/extension id, raising `engines.vscode` past common installs.

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
- [ ] `npx vsce package` → produces `<name>-<X.Y.Z>.vsix`. Inspect the printed file list, confirm only intended files are included.
- [ ] `code --install-extension <name>-<X.Y.Z>.vsix --force`
- [ ] In VS Code: `Cmd/Ctrl+K Cmd/Ctrl+T`, switch each theme, eyeball editor / terminal / markdown / git gutter. Reload window if not applied.
- [ ] Delete any stale older `*.vsix`.

---

## 3. Commit, tag, GitHub Release

- [ ] Commit all release changes. (Respect repo commit-message conventions, check recent `git log`.)
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

## 4. Publish: VS Code Marketplace

Prereq (one-time): publisher exists; an **Azure DevOps PAT** with scope **Marketplace → Manage** (org = "all accessible organizations").

> SECURITY: never paste the token into a shared transcript. Prefer interactive login or an env var set in the operator's own terminal. If an AI agent is driving, have the human run these.

- [ ] `npx vsce login <publisher>`  (paste PAT at the hidden prompt), stores creds.
- [ ] `npx vsce publish`  (reads version from `package.json`).
- [ ] Verify: open `https://marketplace.visualstudio.com/items?itemName=<publisher>.<name>`.
  - Note: `vsce show <publisher>.<name>` caches heavily and lags; trust the `DONE Published` message + the live page.

## 5. Publish: Open VSX

Prereq (one-time): account at open-vsx.org (GitHub login); an **Open VSX access token**; verified namespace.

- [ ] If namespace missing: `npx ovsx create-namespace <publisher> -p <OVSX_TOKEN>`
- [ ] `npx ovsx publish <name>-<X.Y.Z>.vsix -p <OVSX_TOKEN>`
- [ ] Open VSX may queue the version **under review**, public API returns 404 until approved (hours to a day). This is normal, not a failure.
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

# Part 2: JetBrains

Publishes the IntelliJ-platform plugin (Android Studio, IntelliJ, PyCharm, WebStorm, Rider) to the **JetBrains Marketplace**.

> Working directory: the plugin lives under `platforms/jetbrains/plugin/`. Run the Gradle commands from there. The `build.sh` command runs from the repo root.

---

## J0. Choose the version

Semver, same rules as Part 1 (a renamed theme name is breaking because it changes what users have selected).

The version has a single source: the `version=` line in `platforms/jetbrains/plugin/gradle.properties`. Bump it there and nothing else.
- [ ] Set `version=<X.Y.Z>` in `gradle.properties`.

Both build paths read it: Gradle uses it as `project.version` and patches `plugin.xml`; `pack.sh` reads it and stamps `plugin.xml` in the staged copy. The `<version>` committed in `plugin.xml` is only a fallback, so you do not edit it by hand.

---

## J1. Apply file changes

### J1.1 `plugin.xml`
- [ ] `<name>`, `<vendor>` (name, email, url), and `<description>` (CDATA) are accurate. (Version is handled in J0; do not set `<version>` here.)
- [ ] `<idea-version since-build="...">` is the lowest platform you support (`233` = 2023.3). Leave the upper bound open so newer IDEs keep loading it.
- [ ] Add a `<change-notes>` block (CDATA) summarizing this version. The Marketplace shows it on the listing.

### J1.2 Colors
- [ ] All four scheme files (`VesperGoldenDark/Light.theme.json` and `VesperGoldenDark/Light.xml`) are in step with `palette.json` at the repo root.

---

## J2. Build & verify locally

- [ ] Build the zip from the repo root: `scripts/build.sh jetbrains` → `builds/vesper-golden-jetbrains-<X.Y.Z>.zip`. No SDK or network needed.
- [ ] (Optional, needs the SDK) Compatibility check and live preview:
  ```
  cd platforms/jetbrains/plugin
  ./gradlew verifyPlugin   # runs the JetBrains Plugin Verifier
  ./gradlew runIde         # launches a sandbox IDE with the theme loaded
  ```
- [ ] Install the zip from disk in Android Studio (see `install.md`), switch to **Vesper Golden Dark**, and eyeball both the editor and the IDE chrome (toolbars, tool windows, tabs, dialogs).

---

## J3. Commit, tag, GitHub Release

- [ ] Commit and push the changes.
- [ ] Tag the shipped commit. To avoid colliding with Part 1's `v<X.Y.Z>` tags, prefix the JetBrains tag:
  ```
  git tag -a jetbrains-v<X.Y.Z> -m "Vesper Golden (JetBrains) v<X.Y.Z>"
  git push origin jetbrains-v<X.Y.Z>
  ```
- [ ] Create a GitHub Release and attach `builds/vesper-golden-jetbrains-<X.Y.Z>.zip`.

---

## J4. Publish to the JetBrains Marketplace

Prereq (one-time): a vendor account at plugins.jetbrains.com, and a **permanent token** (Marketplace profile > My Tokens).

> The **first** upload of a new plugin must go through the web UI and is **moderated** (can take a few business days). Later versions can be uploaded by web or token.

- [ ] **First release**: plugins.jetbrains.com > **Upload plugin** > select the zip > category **Theme**. Wait for approval.
- [ ] **Updates**: either re-upload the zip on the existing listing, or from `platforms/jetbrains/plugin`:
  ```
  ./gradlew publishPlugin   # uses PUBLISH_TOKEN; downloads the SDK; publishes to the stable channel
  ```
- [ ] (Optional) Sign the plugin first. JetBrains recommends it. `./gradlew signPlugin` with `CERTIFICATE_CHAIN`, `PRIVATE_KEY`, and `PRIVATE_KEY_PASSWORD` set.

> SECURITY: never paste the token into a shared transcript. Use an env var set in the operator's own terminal, or have the human run the publish step.

- [ ] Verify: open the listing at `https://plugins.jetbrains.com/plugin/<id-or-slug>`.

---

## J5. Post-release

- [ ] Confirm the listing shows `<X.Y.Z>` (allow for approval and index lag).
- [ ] Install from the Marketplace in a clean Android Studio: **Settings > Plugins > Marketplace**, search "Vesper Golden".

---

# Part 3: Obsidian

Publishes the theme to the **Obsidian community theme gallery** (Settings > Appearance > Themes > Manage).

> How Obsidian fetches themes: the gallery reads `manifest.json` and `theme.css` from the **root of the default branch** of a public GitHub repo. There is no release-asset step (unlike plugins). Our files live at `platforms/obsidian/theme/`, not the repo root, so the gallery cannot read this monorepo directly. See O3.0 below for the one-time fix.

---

## O0. Choose the version

Semver, same rules as Part 1 (renaming the theme is breaking because it changes what users have selected).

Single source of truth: the `version` field in `platforms/obsidian/theme/manifest.json`. `pack.sh` reads it and stamps the zip name.
- [ ] Set `"version": "<X.Y.Z>"` in `manifest.json`.

`minAppVersion` in the same file gates which Obsidian builds offer the theme. Raise it only if you depend on a newer CSS variable.

---

## O3.0 Publishing repo (one-time)

The gallery needs `manifest.json` + `theme.css` at a repo root. Pick one, once, and reuse it every release:

- [ ] **Mirror repo (recommended)**: a dedicated public repo (e.g. `narayann7/vesper-golden-obsidian`) holding only the theme files at its root, plus a `README.md`, `LICENSE`, and screenshot. A release step copies `platforms/obsidian/theme/{manifest.json,theme.css}` to that repo root and pushes. Keeps this monorepo's layout clean.
- [ ] **Files at monorepo root (not recommended)**: copy the two files to the repo root and point the gallery at `narayann7/vesper-golden`. Pollutes the root and competes with the multi-platform layout.

Record the chosen `repo` as `<obsidian-repo>` for the steps below.

---

## O1. Apply file changes

### O1.1 `manifest.json`
- [ ] `version` set (O0), `name` is exactly `Vesper Golden` (this is what users select; renaming breaks them).
- [ ] `author` and `authorUrl` point at the current GitHub account/repo.
- [ ] `minAppVersion` is the lowest Obsidian build you support.

### O1.2 `theme.css`
- [ ] Colors are in step with `palette.json` at the repo root (both `.theme-dark` and `.theme-light` blocks).

### O1.3 Screenshot
- [ ] A current screenshot exists for the gallery entry (PNG, at least 512px wide, shows the editor + chrome). The gallery entry references it by raw URL.

### O1.4 Validate
- [ ] `manifest.json` parses: `node -e "require('./platforms/obsidian/theme/manifest.json')"` (or `python3 -m json.tool`).
- [ ] `theme.css` loads cleanly in a real vault (no console errors in Obsidian's dev tools).

---

## O2. Build & verify locally

- [ ] Build the zip from the repo root: `scripts/build.sh obsidian` → `builds/vesper-golden-obsidian-<X.Y.Z>.zip`. No network, nothing compiled.
- [ ] Extract into a test vault's `.obsidian/themes/` and enable **Vesper Golden** under Settings > Appearance.
- [ ] Toggle the **Base color scheme** (Light / Dark) and eyeball both: editor text, headings, links, inline + block code, tables, tags, sidebars, tabs.

---

## O3. Commit, sync publishing repo, tag

- [ ] Commit and push the monorepo changes.
- [ ] Sync the publishing repo from O3.0: copy `platforms/obsidian/theme/{manifest.json,theme.css}` to `<obsidian-repo>` root, commit, push to its default branch.
- [ ] Tag the shipped monorepo commit, prefixed to avoid colliding with the other tracks:
  ```
  git tag -a obsidian-v<X.Y.Z> -m "Vesper Golden (Obsidian) v<X.Y.Z>"
  git push origin obsidian-v<X.Y.Z>
  ```

---

## O4. Publish to the Obsidian gallery

> **First release** adds the theme to the gallery via PR and is **reviewed by the Obsidian team** (can take days to weeks). **Updates** need no PR: bump `version` in the publishing repo's `manifest.json` and the gallery picks it up automatically.

- [ ] **First release**: fork `obsidianmd/obsidian-releases`, add an entry to `community-css-themes.json`:
  ```json
  {
    "name": "Vesper Golden",
    "author": "narayann7",
    "repo": "<obsidian-repo>",
    "screenshot": "<raw-screenshot-url>",
    "modes": ["dark", "light"]
  }
  ```
  Open a PR and follow the checklist in their PR template (theme guidelines, no external network calls, license present).
- [ ] **Updates**: just push the new `manifest.json` version to `<obsidian-repo>` (done in O3). No PR.

---

## O5. Post-release

- [ ] First release: PR merged, theme appears in Settings > Appearance > Themes > Manage.
- [ ] Updates: gallery shows `<X.Y.Z>` within a day; users get the update prompt in Manage.
- [ ] Install from the gallery in a clean vault and smoke-test both variants.

---

# Appendix

## Secrets checklist
| Secret | Track | Source | Scope |
|---|---|---|---|
| Azure DevOps PAT | VS Code | dev.azure.com → User Settings → Personal Access Tokens | Marketplace: Manage |
| Open VSX token | VS Code | open-vsx.org → profile → Access Tokens | publish |
| JetBrains permanent token | JetBrains | plugins.jetbrains.com → profile → My Tokens | Marketplace publish |
| Plugin signing key (optional) | JetBrains | your own certificate (chain + private key + password) | sign |

## Optional: CI automation (future)
- **VS Code**: GitHub Action on `v*` tag push: `npm ci` → `vsce package` → `vsce publish` + `ovsx publish`, using repo secrets `VSCE_PAT` and `OVSX_PAT`.
- **JetBrains**: GitHub Action on `jetbrains-v*` tag push: `./gradlew buildPlugin` → `./gradlew publishPlugin`, using repo secret `PUBLISH_TOKEN` (and the signing secrets if enabled).
- **Obsidian**: GitHub Action on `obsidian-v*` tag push: copy `platforms/obsidian/theme/{manifest.json,theme.css}` into the publishing repo and push (using a deploy key or PAT). No marketplace token: gallery updates pull from the repo. First-release PR stays manual.

The first two remove the manual token handling above; Obsidian needs no marketplace secret at all.
