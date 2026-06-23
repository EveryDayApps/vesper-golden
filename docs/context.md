# Project context

A single place to understand Vesper Golden: what it is, how the repo is laid out, how to build each platform, and the rules to follow when adding more. Read this first if you are new to the project (human or agent).

## What it is

Vesper Golden is a warm gold-on-black code theme. It began as a VS Code theme and is growing into a family of ports that share one palette across editors, terminals, and tools. Dark is the primary variant; a light variant exists for VS Code and is planned for the other ports.

The look: near-black background (`#0A0908`), gold accent (`#FFBF3B`) on functions, classes, numbers, and the caret, muted warm grey (`#AFACA7`) for keywords and punctuation, cream (`#F2E7DC`) strings, and italic gold-brown (`#9A8B73`) comments.

## Palette (source of truth)

`palette.json` at the repo root is the canonical color database. It holds both variants (`dark`, `light`), each with a named `palette` (raw hex), a `syntax` map, and `ansi` terminal colors. The `syntax` values are palette keys rather than hex, so a generator resolves `syntax[role]` to `palette[variant][key]` to a hex value.

Every port derives its colors from `palette.json`. A color change starts there and flows outward to each platform. The ports are currently hand-synced to it; a generator that emits them automatically is the planned next step (see `theme-platforms.md`).

| Role | Hex |
|------|------|
| Background | `#0A0908` |
| Background (alt / active line) | `#0D0C0C` |
| Input / inlay background | `#1C1C1C` |
| Border | `#1A1A1A` |
| Foreground | `#FFFFFF` |
| Muted (keywords, params, operators) | `#AFACA7` |
| Dim (line numbers, inactive) | `#707070` |
| Gold accent | `#FFBF3B` |
| Gold hover | `#FFCFA8` |
| Comment (italic) | `#9A8B73` |
| String | `#F2E7DC` |
| Green / Red / Blue (diff, console) | `#7CB342` / `#FF8080` / `#74B3F7` |

## Repo layout

```
vesper-golden/
├── palette.json           canonical color database (source of truth for every port)
├── README.md              repo landing page (multi-platform overview)
├── LICENSE                MIT
├── logo.png               brand mark used by the READMEs
├── manifest.json          Obsidian gallery copy (mirrors platforms/obsidian/theme/manifest.json)
├── theme.css              Obsidian gallery copy (mirrors platforms/obsidian/theme/theme.css)
├── images/                screenshots referenced by raw GitHub URLs
├── scripts/
│   └── build.sh           build any platform into builds/
├── builds/                build output (gitignored)
├── docs/
│   ├── context.md         this file
│   ├── install.md         how to install each port locally
│   ├── release_plan.md    VS Code Marketplace + Open VSX release runbook
│   └── theme-platforms.md map of every platform a theme could ship to
└── platforms/
    ├── vscode/            the VS Code extension (the released flagship port)
    │   ├── package.json   contributes the two themes; vsce packages from here
    │   ├── themes/        vesper-golden-dark / light color-theme.json
    │   ├── README.md      marketplace readme
    │   ├── CHANGELOG.md
    │   ├── LICENSE, logo.png
    │   └── .vscode/, .vscodeignore
    ├── jetbrains/         IntelliJ-platform plugin (Android Studio, IntelliJ, etc.)
    │   ├── README.md
    │   └── plugin/
    │       ├── pack.sh                  build the zip without the IntelliJ SDK
    │       ├── build.gradle.kts         official Gradle build (needs the SDK)
    │       ├── gradle/, gradlew*        committed wrapper
    │       └── src/main/resources/
    │           ├── META-INF/plugin.xml
    │           └── themes/
    │               ├── VesperGoldenDark.theme.json    dark UI theme
    │               ├── VesperGoldenDark.xml           dark editor scheme
    │               ├── VesperGoldenLight.theme.json   light UI theme
    │               └── VesperGoldenLight.xml          light editor scheme
    └── obsidian/          Obsidian theme (dark + light in one theme.css)
        ├── README.md
        └── theme/
            ├── pack.sh           zip the "Vesper Golden/" folder into builds/
            ├── manifest.json     theme name + version (version source of truth)
            └── theme.css         full theme: chrome, markdown, code syntax
```

## Platforms

| Platform | Reach | Status | Format |
|----------|-------|--------|--------|
| VS Code (also Cursor, Windsurf, VSCodium) | High | Released | `*-color-theme.json` |
| JetBrains / Android Studio | High | Builds and installs locally (dark + light) | `*.theme.json` UI + `*.xml` editor scheme |
| Obsidian | Medium | Builds and installs locally (dark + light) | `manifest.json` + `theme.css` |

More candidates (terminals, Slack, Obsidian, and so on) are tracked in `theme-platforms.md`.

## Building

`scripts/build.sh` is the one entry point. It writes every artifact to `builds/` at the repo root.

```
scripts/build.sh            # interactive menu: all / vscode / jetbrains / obsidian
scripts/build.sh all        # build everything (CI-friendly)
scripts/build.sh vscode     # build one
scripts/build.sh vscode jetbrains obsidian
scripts/build.sh list       # print known platforms
```

Output:

```
builds/vesper-golden-vscode-<version>.vsix
builds/vesper-golden-jetbrains-<version>.zip
builds/vesper-golden-obsidian-<version>.zip
```

### How each platform builds

- **vscode**: runs `vsce package` inside `platforms/vscode`, writing the `.vsix` to `builds/`. Needs `node`. First run pulls `@vscode/vsce` through `npx`.
- **jetbrains**: runs `platforms/jetbrains/plugin/pack.sh`, which jars the plugin resources and zips the `<plugin>/lib/<jar>` layout the IDE expects. Stages in a temp dir and writes straight to `builds/`. Needs `jar` and `zip`, no network, no IntelliJ SDK. A theme plugin is pure resources, so nothing is compiled.

- **obsidian**: runs `platforms/obsidian/theme/pack.sh`, which stages a `Vesper Golden/` folder (`manifest.json` + `theme.css`) and zips it into `builds/`. Needs `zip`, no network, nothing compiled. Install by extracting that folder into a vault's `.obsidian/themes/`. The version comes from the `version` field in `manifest.json`.

  The Obsidian community gallery reads `manifest.json` and `theme.css` from the **root of the default branch**, so copies of both live at the repo root and mirror `platforms/obsidian/theme/`. They are the source the gallery serves: re-copy them on every Obsidian release (`cp platforms/obsidian/theme/{manifest.json,theme.css} .`) so the published version matches the port.

There is also `./gradlew buildPlugin` for the JetBrains port. That is the official path but it downloads the IntelliJ SDK (around 1 GB) and writes to gradle's own `build/distributions/` rather than `builds/`. Use `pack.sh` for local work; reach for Gradle when publishing or running `./gradlew runIde` for a live sandbox IDE.

## Installing locally

Full steps per platform are in `install.md`. Short version:

- **VS Code**: install the `.vsix` with `code --install-extension builds/vesper-golden-vscode-<version>.vsix`, or search "Vesper Golden" in the Extensions view once published.
- **Android Studio / JetBrains**: Settings > Plugins > gear > Install Plugin from Disk, pick `builds/vesper-golden-jetbrains-<version>.zip`, restart, then choose the theme under Appearance.
- **Obsidian**: extract `builds/vesper-golden-obsidian-<version>.zip` into your vault's `.obsidian/themes/`, then pick "Vesper Golden" under Settings > Appearance > Themes.

## Adding a new platform

1. Create `platforms/<name>/` and put the port's files there. Derive the colors from `palette.json` at the repo root.
2. Give it a build step. The simplest pattern is a script in the platform dir (like `pack.sh`) that writes its artifact into `builds/` and prints the path.
3. Wire it into `scripts/build.sh`: add a `build_<name>` function and add `<name>` to the `PLATFORMS` list. The function should print the final artifact path on stdout and send any logs to stderr.
4. Document install steps as a new section in `install.md`, and add a row to the tables in this file and the root `README.md`.

## Conventions

- **Build output** always goes to `builds/` (gitignored). Nothing build-generated is committed.
- **The VS Code extension is published**, so treat `platforms/vscode/` carefully. `vsce` packages from that directory; `package.json`, `README.md`, `CHANGELOG.md`, `LICENSE`, and `logo.png` must stay beside it.
- **JetBrains editor schemes are `*.xml`** in the plugin resources (one per variant). They are registered as `bundledColorScheme` so they appear in Settings > Editor > Color Scheme and apply with each theme.
- **No em dashes or en dashes** in docs (a repo-wide writing rule). Use a colon, comma, or a new sentence.
- **node_modules** is gitignored and per-directory. For VS Code work, run `npm install` inside `platforms/vscode`.

## Doc index

- `context.md` (this file): project overview, build, conventions.
- `install.md`: install each port locally, with iteration and uninstall steps.
- `release_plan.md`: runbook for publishing the VS Code extension to the Marketplace and Open VSX.
- `theme-platforms.md`: the full map of platforms a theme could target, grouped by effort and reach.
