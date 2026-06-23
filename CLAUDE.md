# Vesper Golden

Warm gold-on-black code theme. One palette ported across editors, terminals, and tools.

Read `docs/context.md` first. It is the canonical overview: what the project is, repo layout, how each platform builds, install steps, and conventions.

## Source of truth

`palette.json` at the repo root holds every color (dark + light, palette / syntax / ansi). Color changes start there and flow out to each port in `platforms/`.

## Keep the context doc current

**Whenever you change anything important, update `docs/context.md` in the same change.** Important means:

- A new platform or port (`platforms/<name>/`).
- A change to how a platform builds, or to `scripts/build.sh`.
- A palette / color change, or a new variant.
- A new or moved doc, or a change to repo layout.
- A change to the conventions or release process.

Match the existing doc style and update any affected tables (platforms, palette, repo tree). When you touch a port, also check the root `README.md` and `docs/install.md` for rows that need the same edit.

## Conventions

- Build output goes to `builds/` (gitignored). Never commit build artifacts.
- `platforms/vscode/` is published; `vsce` packages from there. Keep `package.json`, `README.md`, `CHANGELOG.md`, `LICENSE`, `logo.png` beside it.
- No em dashes or en dashes in docs. Use a colon, comma, or a new sentence.
- Never add Claude/Anthropic as a commit co-author.
