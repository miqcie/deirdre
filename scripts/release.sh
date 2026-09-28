#!/usr/bin/env bash
# release.sh — keep plugin version, CHANGELOG.md, git tag, and GitHub Release in step.
#   scripts/release.sh bump X.Y.Z   set both manifests to X.Y.Z (commit on a branch, merge via PR)
#   scripts/release.sh publish      on main: tag the manifest version and create the GitHub Release
#   scripts/release.sh notes X.Y.Z  print that version's CHANGELOG section
set -euo pipefail
cd "$(dirname "$0")/.."

notes() { # CHANGELOG section body for $1, without its heading
  awk -v v="$1" '
    $0 ~ "^## \\[" v "\\]" { on = 1; next }
    on && (/^## \[/ || /^\[[0-9]/) { exit }
    on { print }
  ' CHANGELOG.md | perl -0777 -pe 's/\A\s+//; s/\s+\z/\n/'
}

manifest_version() {
  python3 -c 'import json; print(json.load(open(".claude-plugin/plugin.json"))["version"])'
}

case "${1:-}" in
  bump)
    v="${2:?usage: release.sh bump X.Y.Z}"
    [[ "$v" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "not X.Y.Z: $v" >&2; exit 2; }
    [[ -n "$(notes "$v")" ]] || { echo "CHANGELOG.md has no '## [$v]' section; write it first" >&2; exit 1; }
    python3 - "$v" <<'PY'
import json, sys
v = sys.argv[1]
for path, get in ((".claude-plugin/plugin.json", lambda d: d),
                  (".claude-plugin/marketplace.json", lambda d: d["plugins"][0])):
    d = json.load(open(path)); get(d)["version"] = v
    open(path, "w").write(json.dumps(d, indent=2, ensure_ascii=False) + "\n")
PY
    echo "manifests set to $v; commit, open a PR, merge, then: scripts/release.sh publish"
    ;;
  publish)
    [[ "$(git rev-parse --abbrev-ref HEAD)" == main ]] || { echo "run on main" >&2; exit 1; }
    git pull -q --ff-only
    v="$(manifest_version)"
    [[ -z "$(git tag -l "v$v")" ]] || { echo "v$v already tagged; bump first" >&2; exit 1; }
    body="$(notes "$v")"
    [[ -n "$body" ]] || { echo "CHANGELOG.md has no '## [$v]' section" >&2; exit 1; }
    git tag -a "v$v" -m "v$v"
    git push -q origin "v$v"
    gh release create "v$v" --title "v$v" --notes "$body" --latest
    ;;
  notes)
    notes "${2:?usage: release.sh notes X.Y.Z}"
    ;;
  *)
    sed -n 2,5p "$0" >&2; exit 2
    ;;
esac
