#!/usr/bin/env bash
#
# Build Vesper Golden for one or more platforms.
# Artifacts are collected into ./builds at the repo root.
#
# Run it with no arguments for an interactive menu:
#   scripts/build.sh
#     -> pick "all", a single platform, or several (e.g. "1 3")
#
# Or pass targets directly (handy for CI):
#   scripts/build.sh all
#   scripts/build.sh vscode
#   scripts/build.sh vscode jetbrains
#   scripts/build.sh list
#
# Add a platform by writing a build_<name> function and adding <name> to PLATFORMS.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST="$ROOT/builds"

PLATFORMS="vscode jetbrains obsidian"

log()  { printf '\033[1;33m==>\033[0m %s\n' "$*" >&2; }
warn() { printf '\033[1;31m!!\033[0m %s\n' "$*" >&2; }
die()  { warn "$*"; exit 1; }

need() { command -v "$1" >/dev/null 2>&1 || die "missing required tool: $1"; }

# --- per-platform builds -----------------------------------------------------

build_vscode() {
  need node
  local dir="$ROOT/platforms/vscode"
  [ -f "$dir/package.json" ] || die "vscode: package.json not found in $dir"

  local version
  version="$(node -p "require('$dir/package.json').version")"
  local out="$DIST/vesper-golden-vscode-$version.vsix"

  log "vscode: packaging v$version"
  ( cd "$dir" && npx --yes @vscode/vsce package --out "$out" )
  echo "$out"
}

build_jetbrains() {
  need jar
  need zip
  local dir="$ROOT/platforms/jetbrains/plugin"
  [ -x "$dir/pack.sh" ] || die "jetbrains: $dir/pack.sh not found or not executable"

  log "jetbrains: packing plugin"
  # pack.sh writes straight into builds/ and prints the final zip path.
  "$dir/pack.sh"
}

build_obsidian() {
  need zip
  local dir="$ROOT/platforms/obsidian/theme"
  [ -x "$dir/pack.sh" ] || die "obsidian: $dir/pack.sh not found or not executable"

  log "obsidian: packing theme"
  # pack.sh writes straight into builds/ and prints the final zip path.
  "$dir/pack.sh"
}

# --- driver ------------------------------------------------------------------

is_known() {
  case " $PLATFORMS " in *" $1 "*) return 0 ;; *) return 1 ;; esac
}

build_one() {
  local name="$1"
  is_known "$name" || die "unknown platform: $name (known: $PLATFORMS)"
  "build_$name"
}

# Show a numbered menu and echo the chosen platform names.
prompt_targets() {
  local opts=(all $PLATFORMS) i choice picked=""
  {
    echo "Build Vesper Golden. What do you want to build?"
    for i in "${!opts[@]}"; do
      printf "  %d) %s\n" "$((i + 1))" "${opts[$i]}"
    done
    printf "Select (number, or space-separated numbers) [1]: "
  } >&2

  read -r choice
  [ -z "$choice" ] && choice=1

  for n in $choice; do
    case "$n" in
      ''|*[!0-9]*) die "invalid selection: $n" ;;
    esac
    [ "$n" -ge 1 ] && [ "$n" -le "${#opts[@]}" ] || die "out of range: $n"
    local sel="${opts[$((n - 1))]}"
    [ "$sel" = "all" ] && { echo "$PLATFORMS"; return 0; }
    picked="$picked $sel"
  done
  echo "$picked"
}

main() {
  if [ "${1:-}" = "list" ]; then
    echo "$PLATFORMS" | tr ' ' '\n'
    return 0
  fi

  local targets="$*"
  if [ -z "$targets" ]; then
    [ -t 0 ] || die "no platform given and not a terminal (try: scripts/build.sh all)"
    targets="$(prompt_targets)"
  elif [ "$targets" = "all" ]; then
    targets="$PLATFORMS"
  fi

  mkdir -p "$DIST"

  local built=""
  for name in $targets; do
    artifact="$(build_one "$name")"
    built="$built$artifact\n"
  done

  log "done. artifacts in builds/:"
  printf "%b" "$built" | sed 's/^/  /'
}

main "$@"
