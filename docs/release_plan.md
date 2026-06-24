# Release Runbook: Vesper Golden

A repeatable playbook to release each platform. Three independent tracks:

- **Part 1: VS Code** to the **VS Code Marketplace** and **Open VSX**.
- **Part 2: JetBrains** (Android Studio, IntelliJ, and the rest) to the **JetBrains Marketplace**.
- **Part 3: Obsidian** to the **Obsidian community theme gallery**.
- **Part 4: Zed** to the **Zed extension registry**.

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

> How Obsidian fetches themes (current flow, 2026): you publish a **GitHub Release** with `manifest.json` and `theme.css` attached as assets, then submit the repo URL through the **community directory** at community.obsidian.md. The old "open a PR against `obsidianmd/obsidian-releases`" path is gone: that repo has pull requests disabled.
>
> The release **tag must exactly equal** the `version` in `manifest.json` (e.g. tag `1.0.0` for version `1.0.0`). No `v` prefix, no `obsidian-` prefix. So the Obsidian track uses **bare semver tags**, unlike VS Code (`v<X.Y.Z>`) and JetBrains (`jetbrains-v<X.Y.Z>`); the three schemes do not collide.
>
> Because the directory reads the **release assets**, the files no longer have to sit at the repo root. We still keep root copies of `manifest.json` + `theme.css` (harmless, and handy for BRAT beta installs), but they are not what the directory consumes.

---

## O0. Choose the version

Semver, same rules as Part 1 (renaming the theme is breaking because it changes what users have selected).

Single source of truth: the `version` field in `platforms/obsidian/theme/manifest.json`. `pack.sh` reads it and stamps the zip name.
- [ ] Set `"version": "<X.Y.Z>"` in `manifest.json`.

`minAppVersion` in the same file gates which Obsidian builds offer the theme. Raise it only if you depend on a newer CSS variable.

---

## O3.0 Publishing repo (one-time)

The community directory reads the theme from a public GitHub repo: it verifies ownership by your linked GitHub account and pulls `manifest.json` + `theme.css` from the **release assets** (see O4). The repo is this monorepo, `EveryDayApps/vesper-golden`. No mirror repo and no root-file requirement: the directory does not read the repo tree, only the release.

We keep root copies of `manifest.json` + `theme.css` for convenience (BRAT beta installs, quick inspection); re-sync them each release with `cp platforms/obsidian/theme/{manifest.json,theme.css} .`. They are optional, not what the directory consumes.

Record `EveryDayApps/vesper-golden` as `<obsidian-repo>` for the steps below.

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

## O3. Commit, sync root copies, release

- [ ] Commit and push the monorepo changes.
- [ ] Re-sync the root copies: `cp platforms/obsidian/theme/{manifest.json,theme.css} .`, commit, push.
- [ ] Cut a **GitHub Release** whose tag is the bare manifest version (no prefix), with the two files attached as assets:
  ```
  gh release create <X.Y.Z> manifest.json theme.css \
    --repo <obsidian-repo> --target main \
    --title "Vesper Golden (Obsidian) <X.Y.Z>" \
    --notes "<change notes>"
  ```
  The tag (`<X.Y.Z>`) MUST equal `version` in `manifest.json`. The directory rejects a mismatch.

---

## O4. Submit to the Obsidian community directory

> **First release** is submitted once through the web portal and **auto-reviewed**; if it flags issues, fix them and cut a new release with a bumped version. **Updates** need no resubmission: cut a new GitHub Release with the bumped version/tag and the directory picks it up.

This step needs an Obsidian account and GitHub authorization, so a human runs it (an AI agent cannot log in):

- [ ] **First release**: sign in at https://community.obsidian.md with your Obsidian account, link GitHub to verify ownership, open the **Themes** section, submit the repo URL (`https://github.com/<obsidian-repo>`), agree to the developer policies. Address any automated-review feedback by pushing a fix and cutting a new release (O3).
- [ ] **Updates**: just cut a new GitHub Release with the bumped `version`/tag (O3). No resubmission.

---

## O5. Post-release

- [ ] First release: directory review passes, theme appears in Settings > Appearance > Themes > Manage.
- [ ] Updates: gallery shows `<X.Y.Z>` within a day; users get the update prompt in Manage.
- [ ] Install from the gallery in a clean vault and smoke-test both variants.

---

# Part 4: Zed

Publishes the theme extension to the **Zed extension registry** (Zed > Extensions). A Zed theme is pure resources (`extension.toml` + `themes/*.json`): nothing is compiled.

> How Zed distributes extensions (current flow, 2026): the registry is the public repo `zed-industries/extensions`. You add your extension to it as a **git submodule** plus a row in its `extensions.toml`, then open a **PR**. Once merged, Zed builds and serves it; users install from **Extensions** inside the app. There is no per-publisher token and no marketplace upload.
>
> The repo (`EveryDayApps/vesper-golden`) is the submodule source. The registry points at a commit of this repo, so each release is just a newer commit plus a version bump in the registry's `extensions.toml`.
>
> Working directory: the extension lives under `platforms/zed/`. `build.sh` runs from the repo root.

---

## Z0. Choose the version

Semver, same rules as Part 1 (renaming the theme is breaking because it changes what users have selected).

Single source of truth: the `version` field in `platforms/zed/extension.toml`. `pack.sh` reads it and stamps the zip name.
- [ ] Set `version = "<X.Y.Z>"` in `extension.toml`.

`schema_version` only changes if Zed's extension format changes; leave it unless the docs say otherwise.

---

## Z1. Apply file changes

### Z1.1 `extension.toml`
- [ ] `version` set (Z0), `id` is `vesper-golden`, `name` is exactly `Vesper Golden` (this is what users select; renaming breaks them).
- [ ] `authors`, `repository`, `description` point at the current GitHub account/repo.

### Z1.2 `themes/vesper-golden.json`
- [ ] Colors are in step with `palette.json` at the repo root (both `Vesper Golden Dark` and `Vesper Golden Light` blocks).
- [ ] `name` of each theme matches what users select (renaming breaks their setting).

### Z1.3 Validate
- [ ] Theme JSON parses: `python3 -c "import json;json.load(open('platforms/zed/themes/vesper-golden.json'))"` (or `node -e "require('./platforms/zed/themes/vesper-golden.json')"`).

---

## Z2. Build & verify locally

- [ ] Build the zip from the repo root: `scripts/build.sh zed` → `builds/vesper-golden-zed-<X.Y.Z>.zip`. No network, nothing compiled.
- [ ] Live install without building: `cp platforms/zed/themes/vesper-golden.json ~/.config/zed/themes/`, then `cmd-k cmd-t` and pick **Vesper Golden Dark** / **Light**. Zed live-reloads on save.
- [ ] Dev-extension install: **Extensions > Install Dev Extension**, point at the `vesper-golden/` folder inside the built zip. Eyeball editor syntax, terminal, tabs, panels, status bar in both variants.

---

## Z3. Commit, tag, GitHub Release

- [ ] Commit and push the monorepo changes.
- [ ] Tag the shipped commit. To avoid colliding with the other tracks' tags, prefix the Zed tag:
  ```
  git tag -a zed-v<X.Y.Z> -m "Vesper Golden (Zed) v<X.Y.Z>"
  git push origin zed-v<X.Y.Z>
  ```
- [ ] (Optional) Create a GitHub Release and attach `builds/vesper-golden-zed-<X.Y.Z>.zip`. The registry does not consume it; it is for direct download.

---

## Z4. Publish to the Zed extension registry

Prereq: a GitHub account (the registry is a public repo; no token or marketplace login).

> The **first** publish adds the extension to `zed-industries/extensions`. **Updates** bump the submodule pointer and the version in that repo's `extensions.toml`. Both are PRs that a Zed maintainer merges.

- [ ] Fork `zed-industries/extensions`.
- [ ] **First release**: add this repo as a submodule under `extensions/vesper-golden`, add a `[vesper-golden]` row to `extensions.toml` (`submodule`, `version`, `path`), commit, open a PR. Follow the repo's `CONTRIBUTING` for the exact layout.
- [ ] **Updates**: in your fork, update the submodule to the new commit and bump `version` under `[vesper-golden]` in `extensions.toml` to `<X.Y.Z>`, commit, open a PR.
- [ ] Verify after merge: the version shows on the extension in Zed's **Extensions** view (allow for the registry build + index lag).

---

## Z5. Post-release

- [ ] Confirm the registry shows `<X.Y.Z>` once the PR merges and builds.
- [ ] Install from **Extensions** in a clean Zed and smoke-test both variants.

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
- **Obsidian**: GitHub Action on a bare-semver tag push (e.g. `1.0.0`, matching `manifest.json`): cut a GitHub Release attaching `manifest.json` + `theme.css`. No marketplace token: the community directory pulls updates from the release. The first-release portal submission at community.obsidian.md stays manual (needs an Obsidian-account login).

The first two remove the manual token handling above; Obsidian needs no marketplace secret at all.
