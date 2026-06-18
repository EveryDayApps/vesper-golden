# Change Log

## [1.0.0] - 2026-06-18

First stable release. Now ships **two** themes: `Vesper Golden Dark` and `Vesper Golden Light`.

#### Added

- New light theme variant `Vesper Golden Light` — keeps the golden accents on a clean, bright background.
- Dark + light syntax/contrast pass: WCAG-readable comments, real terminal green (was gold), bracket-pair colorization, and visible markdown fenced code blocks.
- Updated package keywords to include light theme support.

#### Changed

- **Breaking:** theme labels renamed to `Vesper Golden Dark` / `Vesper Golden Light`. Update your `workbench.colorTheme` setting (old value `"vesper golden"` no longer matches).
- Renamed dark theme file and preview images to a dark/light naming convention.

#### Fixed

- Removed duplicate `Comment` token rule, dead root-level bracket colors, and off-palette selection highlight in both themes.

## [0.0.1] - 2025-06-01

#### Added

- Initial release of the vesper golden theme for Visual Studio Code.
- Based on the Vesper Black theme, adapted for a golden color scheme.
- Includes support for various programming languages and file types.
- Provides a visually appealing dark theme with golden accents.

## [0.0.3] - 2025-06-02

#### Added

- Updated README with installation instructions and recommended settings.

#### Removed

- Removed vsix file from the repository which reduces the size of the theme package.

## [0.0.5] - 2025-06-02

#### Fixed

- Fixed theme size by removing unnecessary files and folders.
- Sized Reduced the theme package size from 1.2 MB to 8KB.

## [0.0.7] - 2025-06-29

#### Updated

- Color adjustments for Terminal, Git decorations, Comment, and miscellaneous scopes.
- Changed engines vscode version to 1.100.0 to 1.43.0 to support older versions of VS Code.
