#!/bin/sh
# Pack the theme plugin into an installable zip without the IntelliJ SDK.
# A theme plugin is pure resources, so no compilation is needed.
# Use this when `./gradlew buildPlugin` is unavailable (no network for the SDK).
#
# Output goes to the repo-root builds/ directory. Prints the final zip path.
set -e
cd "$(dirname "$0")"                 # platforms/jetbrains/plugin
ROOT="$(cd ../../.. && pwd)"

NAME="vesper-golden"                 # plugin dir name inside the zip (must stay this)

# Single source of truth for the version: the `version=` line in gradle.properties.
VERSION="$(sed -n 's/^version=//p' gradle.properties | head -1)"
[ -n "$VERSION" ] || { echo "pack.sh: no version= in gradle.properties" >&2; exit 1; }

OUTDIR="$ROOT/builds"
OUT="$OUTDIR/$NAME-jetbrains-$VERSION.zip"
mkdir -p "$OUTDIR"

# Stage the <plugin>/lib/<jar> layout in a temp dir so nothing is left under plugin/.
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/$NAME/lib"

# Copy resources to the stage and stamp the version into plugin.xml, so the
# committed plugin.xml never has to be kept in sync by hand.
cp -R src/main/resources "$STAGE/res"
perl -0pi -e "s{<version>.*?</version>}{<version>$VERSION</version>}s" "$STAGE/res/META-INF/plugin.xml"

# jar the (patched) plugin.xml + theme resources
( cd "$STAGE/res" && jar cf "$STAGE/$NAME/lib/$NAME.jar" META-INF themes )

# zip the staged layout into builds/
rm -f "$OUT"
( cd "$STAGE" && zip -r -q "$OUT" "$NAME" )

echo "$OUT"
