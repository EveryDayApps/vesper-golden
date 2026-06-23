# Vesper Golden: local install

How to load and test Vesper Golden locally without publishing anything. One section per platform.

## VS Code

Works the same in Cursor, Windsurf, and VSCodium.

### Install the built extension

Build the `.vsix`, then install it:

```
scripts/build.sh vscode
code --install-extension builds/vesper-golden-vscode-1.0.0.vsix
```

Or install through the UI: **Extensions** view (`Cmd+Shift+X`) > the `...` menu at the top > **Install from VSIX...** > pick the file in `builds/`.

Then activate it: **Cmd+K Cmd+T** (Preferences: Color Theme) and choose **Vesper Golden Dark** or **Vesper Golden Light**.

### Iterate on the theme (live preview)

For editing the theme itself, skip the build loop:

1. Open `platforms/vscode` in VS Code.
2. Press **F5** (or Run > Start Debugging). A second VS Code window opens, the Extension Development Host, with the theme already loaded.
3. In that window, pick the theme with **Cmd+K Cmd+T**.
4. Edit `themes/vesper-golden-dark-color-theme.json` in the first window. Reload the host window (**Cmd+R**) to see changes.

To uninstall: **Extensions** view, find **Vesper Golden**, gear icon, **Uninstall**.

## Android Studio

The plugin ships both variants (Dark and Light). Each one is a full IDE theme (toolbars, sidebars, tabs, dialogs) plus a matching editor color scheme, and both editor schemes are registered so they show up under **Editor > Color Scheme**.

The same zip works in any JetBrains IDE (IntelliJ, PyCharm, WebStorm, Rider). Android Studio is documented here; the steps are identical elsewhere.

### Build the plugin zip

Easiest from the repo root:

```
scripts/build.sh jetbrains
```

This runs `pack.sh` under the hood (fast, no network, no SDK) and writes:

```
builds/vesper-golden-jetbrains-1.1.0.zip
```

Lower-level options, run from `platforms/jetbrains/plugin`:

```
./pack.sh               # same as above; writes to builds/ at the repo root
./gradlew buildPlugin   # the standard way; downloads the IntelliJ SDK on first run,
                        # output lands in build/distributions/ instead of builds/
```

### Install it

1. Open **Settings** (`Cmd+,` on macOS, `Ctrl+Alt+S` on Windows/Linux).
2. Go to **Plugins**.
3. Gear at the top, then **Install Plugin from Disk...**.
4. Select the zip above.
5. Restart when prompted.
6. **Appearance & Behavior > Appearance > Theme** and pick **Vesper Golden Dark** or **Vesper Golden Light**.

The matching editor scheme applies with the theme. To check or change it directly, see **Editor > Color Scheme**; both **Vesper Golden Dark** and **Vesper Golden Light** are listed there.

> Upgrading from an older build? If you ever imported a Vesper Golden scheme by hand (an early version of this guide had you do that), delete that copy under **Editor > Color Scheme** (gear, **Delete**). A pinned manual scheme overrides the plugin and stops the editor from switching with the theme.

### Editor colors only (no UI theme)

If you want the code colored but want to keep your current IDE chrome, leave the **Theme** as-is and just set **Editor > Color Scheme** to **Vesper Golden Dark** or **Vesper Golden Light**. The schemes assume a matching background, so a dark scheme reads best on a dark UI theme and the light scheme on a light one.

### Iterate with a sandbox IDE

```
cd platforms/jetbrains/plugin
./gradlew runIde
```

Launches a throwaway IntelliJ with the theme preloaded. Edit the files under `src/main/resources/themes/` (`*.theme.json` for UI, `*.xml` for the editor scheme), stop, and re-run to see changes.

To uninstall: **Settings > Plugins**, find **Vesper Golden**, **Uninstall**, restart.

## Obsidian

A full theme: app chrome, markdown reading and edit views, and code-block syntax. Ships both variants (Dark and Light), switched with Obsidian's own light/dark toggle.

### Install from the community gallery (recommended)

1. In Obsidian, open **Settings > Appearance > Themes**, click **Manage**.
2. Search **Vesper Golden**, click **Install and use**.
3. Toggle the **Base color scheme** (Light / Dark) to switch variants.

Listing: https://community.obsidian.md/themes/vesper-golden. Updates arrive through **Manage > Check for updates**.

### Build the theme zip

From the repo root:

```
scripts/build.sh obsidian
```

This runs `pack.sh` under the hood (fast, no network, nothing compiled) and writes:

```
builds/vesper-golden-obsidian-1.0.0.zip
```

### Install it

The zip holds a `Vesper Golden/` folder with `manifest.json` and `theme.css`.

1. Extract the zip into your vault's themes folder: `<vault>/.obsidian/themes/`. You should end up with `<vault>/.obsidian/themes/Vesper Golden/`.
2. In Obsidian, open **Settings > Appearance**.
3. Under **Themes**, pick **Vesper Golden**.
4. Use the **Base color scheme** toggle (Light / Dark) to switch variants.

### Iterate on the theme (live reload)

For editing the theme itself, point the build straight at a vault and reload:

1. Copy `platforms/obsidian/theme/` to `<vault>/.obsidian/themes/Vesper Golden/` (or symlink it).
2. Edit `theme.css`.
3. In Obsidian, run the command **Reload app without saving** (or toggle the theme off and on) to see changes.

To uninstall: delete the `Vesper Golden` folder under `<vault>/.obsidian/themes/`, or switch back to the default theme in **Settings > Appearance**.

## Where the colors come from

Every scheme derives from `palette.json` at the repo root (the canonical color database, with both dark and light variants).

| Role | Dark | Light |
|------|------|-------|
| Background | `#0A0908` | `#FEFEFE` |
| Foreground | `#FFFFFF` | `#2C2C2C` |
| Accent (functions, classes, numbers) | `#FFBF3B` | `#B8860B` |
| Muted (keywords, params, operators) | `#AFACA7` | `#616161` |
| Comment (italic) | `#9A8B73` | `#7A6248` |
| String | `#F2E7DC` | `#5D4037` |

## What's next

- **Publish**: ship the plugin to JetBrains Marketplace so it installs in one click instead of building from source.
- **Other JetBrains IDEs**: the same zip already works in IntelliJ, PyCharm, WebStorm, and Rider with no changes.
