#!/bin/sh
# Pack the Obsidian theme into an installable zip.
# An Obsidian theme is pure resources (manifest.json + theme.css), so nothing
# is compiled. The zip holds a "Vesper Golden/" folder: extract it into a
# vault's .obsidian/themes/ and the theme appears under Appearance > Themes.
#
# Output goes to the repo-root builds/ directory. Prints the final zip path.
set -e
cd "$(dirname "$0")"                 # platforms/obsidian/theme
ROOT="$(cd ../../.. && pwd)"

NAME="Vesper Golden"                 # theme folder name inside the zip (== manifest name)

# Single source of truth for the version: the "version" field in manifest.json.
VERSION="$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' manifest.json | head -1)"
[ -n "$VERSION" ] || { echo "pack.sh: no version in manifest.json" >&2; exit 1; }

OUTDIR="$ROOT/builds"
OUT="$OUTDIR/vesper-golden-obsidian-$VERSION.zip"
mkdir -p "$OUTDIR"

# Stage the "Vesper Golden/" layout in a temp dir so nothing is left behind.
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/$NAME"
cp manifest.json theme.css "$STAGE/$NAME/"

rm -f "$OUT"
( cd "$STAGE" && zip -r -q "$OUT" "$NAME" )

echo "$OUT"
