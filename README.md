<div align="center">
  <img alt="vesper-golden" height="80" src="https://raw.githubusercontent.com/EveryDayApps/vesper-golden/main/logo.png">
  <h1>Vesper Golden</h1>
  <p>A warm gold-on-black theme. Dark and light.</p>

  <p>
    <!-- shields.io retired its visual-studio-marketplace badges, so VS Marketplace uses badgen. -->
    <a href="https://marketplace.visualstudio.com/items?itemName=narayann7.vesper-golden"><img src="https://badgen.net/vs-marketplace/v/narayann7.vesper-golden?label=vs%20marketplace&color=FFBF3B" alt="VS Marketplace Version" /></a>
    <a href="https://marketplace.visualstudio.com/items?itemName=narayann7.vesper-golden"><img src="https://badgen.net/vs-marketplace/i/narayann7.vesper-golden?label=installs" alt="VS Marketplace Installs" /></a>
    <a href="https://open-vsx.org/extension/narayann7/vesper-golden"><img src="https://img.shields.io/open-vsx/v/narayann7/vesper-golden?style=flat-square&label=open%20vsx&color=FFBF3B" alt="Open VSX Version" /></a>
    <a href="https://open-vsx.org/extension/narayann7/vesper-golden"><img src="https://img.shields.io/open-vsx/dt/narayann7/vesper-golden?style=flat-square&label=downloads" alt="Open VSX Downloads" /></a>
    <!-- JetBrains plugin 32415 is in Marketplace review; badges populate once it is approved. -->
    <a href="https://plugins.jetbrains.com/plugin/32415-vesper-golden"><img src="https://img.shields.io/jetbrains/plugin/v/32415?style=flat-square&label=jetbrains&color=FFBF3B" alt="JetBrains Version" /></a>
    <a href="https://plugins.jetbrains.com/plugin/32415-vesper-golden"><img src="https://img.shields.io/jetbrains/plugin/d/32415?style=flat-square&label=downloads" alt="JetBrains Downloads" /></a>
    <a href="https://github.com/EveryDayApps/vesper-golden/blob/main/LICENSE"><img src="https://img.shields.io/github/license/EveryDayApps/vesper-golden?style=flat-square" alt="License" /></a>
    <a href="https://github.com/EveryDayApps/vesper-golden"><img src="https://img.shields.io/github/stars/EveryDayApps/vesper-golden?style=social" alt="Stars" /></a>
  </p>
</div>

Vesper Golden started as a VS Code theme and is growing into a family of ports that share one palette across editors, terminals, and tools.

<div align="center">
  <a href="https://narayann.dev/apps/vesper-golden">
    <img alt="Vesper Golden preview" src="https://raw.githubusercontent.com/EveryDayApps/vesper-golden/main/images/site/image.png" width="800">
  </a>
  <p><sub><a href="https://narayann.dev/apps/vesper-golden">More previews on narayann.dev</a></sub></p>
</div>

## Platforms

| Platform | Status | Where |
|----------|--------|-------|
| VS Code (and Cursor, Windsurf, VSCodium) | Released | [`platforms/vscode`](platforms/vscode) |
| JetBrains / Android Studio | Buildable locally | [`platforms/jetbrains`](platforms/jetbrains) |

More ports (terminals, and other tools) are tracked in [`docs/theme-platforms.md`](docs/theme-platforms.md).

## Build

`scripts/build.sh` builds any platform and drops the artifact in `builds/`. Run it with no arguments for a menu, or name a target:

```
scripts/build.sh            # interactive menu
scripts/build.sh all        # every platform
scripts/build.sh vscode     # just one
scripts/build.sh vscode jetbrains
scripts/build.sh list       # print known platforms
```

## Install

- **VS Code**: search "Vesper Golden" in the Extensions view, or see [`platforms/vscode/README.md`](platforms/vscode/README.md).
- **Android Studio / JetBrains**: build and load the plugin by following [`docs/install.md`](docs/install.md).

## Repo layout

```
palette.json   canonical color database (source of truth for every port)
platforms/
  vscode/      VS Code extension (released flagship port)
  jetbrains/   IntelliJ-platform plugin: UI theme + editor scheme
scripts/       build.sh: build any platform into builds/
docs/          install guide, release runbook, platform map
images/        screenshots used by the READMEs
builds/        build output (gitignored)
```

`palette.json` is the color source. Every port derives from it, so a color change starts there and flows outward.

## License

[MIT](LICENSE)
