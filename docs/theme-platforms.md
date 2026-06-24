# Theme Platforms

Targets where a "Vesper Golden" theme family can ship. Grouped by effort and reach. Format column = what file/syntax each port needs.

## Tier 1: Code Editors (highest reach, you already here)

| Platform | Format | Marketplace | Notes |
|----------|--------|-------------|-------|
| **VS Code** | JSON (`*-color-theme.json`) | VS Code Marketplace + OpenVSX | Already shipped. Source of truth. |
| **Cursor** | VS Code JSON (same) | Uses OpenVSX | Free: same package installs. |
| **Windsurf** | VS Code JSON (same) | OpenVSX | Free: same package. |
| **VSCodium** | VS Code JSON (same) | OpenVSX | Free: same package. |
| **JetBrains (IntelliJ/PyCharm/WebStorm/etc.)** | `.xml` editor scheme + `.theme.json` UI | JetBrains Marketplace | Shipped. Separate plugin project. |
| **Sublime Text** | `.sublime-color-scheme` (JSON) or `.tmTheme` (XML plist) | Package Control | tmTheme is portable base format. |
| **Zed** | `.json` theme | Zed extensions repo | Growing fast. Simple JSON. |
| **Neovim** | Lua colorscheme | GitHub (lazy/packer) | Highest dev-cred. Lua + highlight groups. |
| **Vim** | `.vim` colorscheme | GitHub | Classic. Terminal + GUI variants. |
| **Emacs** | `.el` (deftheme) | MELPA | Niche but loyal. |
| **Helix** | `.toml` | Helix runtime repo | Simple TOML. |
| **Atom** (dead) | LESS | n/a | Skip: discontinued. |

## Tier 2: Terminals (easy ports, big visual impact)

| Platform | Format | Distribution |
|----------|--------|--------------|
| **iTerm2** | `.itermcolors` (XML plist) | GitHub / iterm2colorschemes |
| **Windows Terminal** | JSON fragment | GitHub |
| **Alacritty** | `.toml` / `.yml` | GitHub |
| **Kitty** | `.conf` | GitHub |
| **WezTerm** | Lua / TOML | GitHub |
| **Ghostty** | theme config | Built-in theme dir |
| **Hyper** | JS plugin | npm |
| **Terminal.app (macOS)** | `.terminal` (XML plist) | GitHub |
| **GNOME Terminal / Tilix** | shell script / dconf | GitHub |
| **Konsole** | `.colorscheme` | GitHub |
| **tmux** | `.conf` | GitHub (tpm) |
| **Warp** | `.yaml` | Warp themes repo |

## Tier 3: Tools & Apps (long tail, brand spread)

| Platform | Format |
|----------|--------|
| **Slack** | sidebar hex string (paste) |
| **Discord** (BetterDiscord) | CSS theme |
| **Obsidian** (shipped) | full `theme.css` theme, in the community gallery |
| **Notion** (unofficial) | CSS |
| **GitHub** (Refined/userstyle) | Stylus CSS |
| **Firefox** | `manifest.json` (WebExtension theme) |
| **Chrome** | `manifest.json` theme |
| **Telegram** | `.tdesktop-theme` / attheme |
| **Spotify** (Spicetify) | `color.ini` + CSS |
| **Bat** (cat clone) | Sublime `.tmTheme` (reused!) |
| **Delta** (git diff) | Sublime `.tmTheme` (reused!) |
| **K9s** | `.yaml` skin |
| **Lazygit** | `.yml` |
| **Starship** prompt | `.toml` |
| **Rofi / Wofi** | `.rasi` / CSS |
| **GTK / Qt** (desktop) | CSS / qss |

## Reuse map: one format covers many

- **Sublime `.tmTheme`** covers Sublime, bat, delta, others. Build once.
- **VS Code JSON** covers VS Code, Cursor, Windsurf, VSCodium. One package, 4 editors.
- **Base16 / Base24 spec** auto-generates 100+ apps via templates. Strong shortcut.

## Recommended build order

1. VS Code (done): also covers Cursor/Windsurf/VSCodium free.
2. **Define palette as single source** (`palette.json` or Base16 YAML).
3. **iTerm2 + Windows Terminal + Alacritty**: cheap, high visual payoff.
4. **JetBrains** (done): large separate audience.
5. **Neovim + tmux**: dev-cred, screenshot-friendly combos.
6. **Sublime `.tmTheme`**: unlocks bat + delta for free.
7. Long tail (Slack/Discord and the rest) as community asks. Obsidian is already shipped.

## Generator strategy

Don't hand-maintain N ports. Pick one:
- **Base16/Base24** framework: write one YAML scheme, community templates emit ~100 apps. Fastest path to breadth.
- **Custom generator**: `palette.json` to per-port templates. Full control (Catppuccin model, "whiskers").

Base16 = speed. Custom = control + brand polish. Hybrid common: custom for flagship editors, Base16 for long tail.
