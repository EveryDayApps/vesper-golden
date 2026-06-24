# Vesper Golden: Zed

Zed port. A full theme family (dark + light) in the warm gold-on-black palette, covering editor syntax, terminal ANSI, and app chrome. Colors derive from the repo-root `palette.json`.

- `themes/vesper-golden.json` is the theme: one family file with both `Vesper Golden Dark` and `Vesper Golden Light`.
- `extension.toml` is the Zed extension manifest (name and version).
- Build the installable zip with `./pack.sh` (no network, nothing compiled).

## Install locally (no build)

Copy the theme file straight into Zed's user themes directory, then pick it:

```
cp themes/vesper-golden.json ~/.config/zed/themes/
```

Open the theme selector with `cmd-k cmd-t` (or **Settings > Theme**) and choose `Vesper Golden Dark` / `Vesper Golden Light`. Zed live-reloads files in that directory, so edits show on save.

## Install as an extension

The zip from `pack.sh` holds a `vesper-golden/` folder in Zed's extension layout. Install it through **Extensions > Install Dev Extension** and point at that folder. Publishing to the Zed extension registry is a PR to `zed-industries/extensions` that adds this extension as a submodule.

Full install and iteration steps are in [`../../docs/install.md`](../../docs/install.md).
