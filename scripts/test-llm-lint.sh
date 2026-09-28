#!/usr/bin/env bash
# Self-check for llm-lint.sh. Run: bash scripts/test-llm-lint.sh
set -u
lint="$(dirname "$0")/llm-lint.sh"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
bad=0

check() { # name, expected exit, file, [text the output must contain]
  local out rc
  out="$(bash "$lint" "$3")"; rc=$?
  if [[ "$rc" -ne "$2" ]]; then echo "FAIL $1: exit $rc, want $2"; echo "$out"; bad=1; return; fi
  if [[ -n "${4:-}" && "$out" != *"$4"* ]]; then echo "FAIL $1: output lacks '$4'"; echo "$out"; bad=1; return; fi
  echo "ok   $1"
}

# A tic in the author's own prose still fails, with the true line number.
printf 'Fine line.\n\nWe leverage a robust ecosystem.\n' > "$tmp/use.md"
check "real use fails" 1 "$tmp/use.md" "3:We leverage"

# Quoted, blockquoted, and code mentions are examples, not uses.
cat > "$tmp/mention.md" <<'EOF'
---
title: "A paradigm shift"
---
The tells include "It's not just a tool, it's a paradigm shift." and "Moreover."
> "There are several reasons why this approach is highly effective."
Run `grep -i leverage` to find them.
```
Moreover, this is very robust.
```
EOF
check "mentions pass" 0 "$tmp/mention.md" "PASS"

# The ignore marker skips a deliberate use.
printf 'Know what to leverage. <!-- llm-lint: ignore -->\n' > "$tmp/ignore.md"
check "ignore marker passes" 0 "$tmp/ignore.md" "PASS"

exit "$bad"
