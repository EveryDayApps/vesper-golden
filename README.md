<div align="center">
  <img alt="vesper-golden" height="80" src="https://raw.githubusercontent.com/EveryDayApps/vesper-golden/main/logo.png">
  <h1>Vesper Golden</h1>
  <p>A warm gold-on-black theme. Dark and light.</p>
</div>

Vesper Golden started as a VS Code theme and is growing into a family of ports that share one palette across editors, terminals, and tools.

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
