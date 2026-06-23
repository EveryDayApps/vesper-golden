<div align="center">

<img alt="vesper-golden" height="96" src="https://raw.githubusercontent.com/EveryDayApps/vesper-golden/main/logo.png">

# Vesper Golden

**A warm gold-on-black theme. Dark and light.**

One palette, shared across editors, terminals, and tools.

<br/>

<!-- Downloads per platform, single row. shields.io retired its VS Marketplace badges, so VS Marketplace uses badgen. JetBrains 32415 badge populates after review. Obsidian has no official download badge, so it links to the gallery. -->
[![VS Marketplace Downloads](https://badgen.net/vs-marketplace/d/narayann7.vesper-golden?label=vs%20marketplace&color=FFBF3B)](https://marketplace.visualstudio.com/items?itemName=narayann7.vesper-golden) [![Open VSX Downloads](https://img.shields.io/open-vsx/dt/narayann7/vesper-golden?style=flat-square&label=open%20vsx&color=FFBF3B)](https://open-vsx.org/extension/narayann7/vesper-golden) [![JetBrains Downloads](https://img.shields.io/jetbrains/plugin/d/32415?style=flat-square&label=jetbrains&color=FFBF3B)](https://plugins.jetbrains.com/plugin/32415-vesper-golden) [![Obsidian](https://img.shields.io/badge/obsidian-gallery-FFBF3B?style=flat-square)](https://community.obsidian.md/themes/vesper-golden) [![Stars](https://img.shields.io/github/stars/EveryDayApps/vesper-golden?style=social)](https://github.com/EveryDayApps/vesper-golden)

<br/>

<a href="https://narayann.dev/apps/vesper-golden">
  <img alt="Vesper Golden preview" src="https://raw.githubusercontent.com/EveryDayApps/vesper-golden/main/images/site/screenshot.png" width="820">
</a>

<br/>
<br/>

[![See more previews on narayann.dev](https://img.shields.io/badge/See%20more%20previews-narayann.dev-FFBF3B?style=for-the-badge&logoColor=black)](https://narayann.dev/apps/vesper-golden)

</div>

## Platforms

| Platform | Status | Where |
|----------|--------|-------|
| VS Code (and Cursor, Windsurf, VSCodium) | Released | [`platforms/vscode`](platforms/vscode) |
| JetBrains / Android Studio | Buildable locally | [`platforms/jetbrains`](platforms/jetbrains) |
| Obsidian | Released | [community gallery](https://community.obsidian.md/themes/vesper-golden) |

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
- **Obsidian**: **Settings > Appearance > Themes > Manage**, search "Vesper Golden". Also in the [community gallery](https://community.obsidian.md/themes/vesper-golden). Local build steps are in [`docs/install.md`](docs/install.md).

## Repo layout

```
palette.json   canonical color database (source of truth for every port)
platforms/
  vscode/      VS Code extension (released flagship port)
  jetbrains/   IntelliJ-platform plugin: UI theme + editor scheme
  obsidian/    Obsidian theme: manifest.json + theme.css
scripts/       build.sh: build any platform into builds/
docs/          install guide, release runbook, platform map
images/        screenshots used by the READMEs
builds/        build output (gitignored)
```

`palette.json` is the color source. Every port derives from it, so a color change starts there and flows outward.

## License

[MIT](LICENSE)
