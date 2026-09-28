#!/usr/bin/env bash
# llm-lint.sh — flag the mechanical LLM writing tics from skills/deirdre/STYLE_GUIDE.md
# Usage: scripts/llm-lint.sh path/to/post.md
# Exit 1 if any HARD rule fires. WARN rules print but don't fail (they need judgment).
# ponytail: grep-based, not an NLP grader — catches the mechanical tics, the human ear catches the rest.
#
# Only the author's own prose is checked. Blanked before matching (line numbers stay true):
#   front matter, fenced code, `inline code`, > blockquotes, and "quoted text" (a quoted tic is a mention, not a use).
# Deliberate use: put <!-- llm-lint: ignore --> on the line and the whole line is skipped.

set -u

file="${1:-}"
if [[ -z "$file" || ! -f "$file" ]]; then
  echo "usage: $0 path/to/file.md" >&2
  exit 2
fi

prose="$(mktemp)"
trap 'rm -f "$prose"' EXIT
perl -CSD -ne '
  if ($. == 1 && /^---\s*$/) { $fm = 1; print "\n"; next }
  if ($fm) { $fm = 0 if /^---\s*$/; print "\n"; next }
  if (/^\s*(```|~~~)/) { $fence = !$fence; print "\n"; next }
  if ($fence || /llm-lint:\s*ignore/ || /^\s*>/) { print "\n"; next }
  s/`[^`]*`//g;
  s/"[^"]*"//g;
  s/\x{201C}[^\x{201D}]*\x{201D}//g;
  print;
' "$file" > "$prose"

fail=0

# print the original lines whose prose matches the pattern
matches() {
  local nums
  nums="$(grep -nEi "$1" "$prose" | cut -d: -f1)"
  [[ -z "$nums" ]] && return
  awk 'NR == FNR { want[$1]; next } FNR in want { print "    " FNR ":" $0 }' <(echo "$nums") "$file"
}

# hard rule: print matches and mark failure
hard() {
  local hits
  hits="$(matches "$2")"
  if [[ -n "$hits" ]]; then
    echo "FAIL [$1]"
    echo "$hits"
    fail=1
  fi
}

# warn rule: print matches, never fail
warn() {
  local hits
  hits="$(matches "$2")"
  if [[ -n "$hits" ]]; then
    echo "WARN [$1] (review by hand)"
    echo "$hits"
  fi
}

# --- HARD rules (mechanical, safe to auto-fail) ---
hard "1 not-X-its-Y antithesis"   "(it'?s not (just )?[^.]{1,40}[,.] (it'?s|but) |not (just )?about [^.]{1,40}, (it'?s|but) about)"
hard "3 inflated adjectives"      "\b(revolutionary|transformative|groundbreaking|unprecedented|paradigm shift|game[- ]?changer)\b"
hard "4 filler openers"           "(it is important to note|needless to say|no discussion would be complete|in today'?s fast-paced)"
hard "5 generic abstractions"     "\b(leverage|synergy|robust|scalable|seamless|best-in-class|next-gen|holistic|ecosystem|landscape)\b"
hard "6 stock cliches"            "(stands as a testament|plays a (vital|key|crucial) role|at the end of the day|when it comes to)"
hard "7 mechanical transitions"   "^\s*(Moreover|Furthermore|Additionally|In conclusion|Overall|In summary)\b"
hard "9 qualifiers/intensifiers"  "\b(very|really|quite|extremely|highly|incredibly|truly)\b"
hard "12 metacommentary"          "(as an ai|this (article|post) will (explore|delve|examine)|we will delve|let'?s dive)"

# --- WARN rules (need human judgment; some hits are legitimate) ---
warn "8 absolutist claims"        "\b(always|never|the only way|every single)\b"
warn "10 hedging"                 "\b(might|could|possibly|perhaps)\b"
warn "11 unsourced authority"     "(studies show|experts agree|research suggests)"
warn "13 rule-of-three"           "[a-z]+, [a-z]+,( and| or) [a-z]+\."
warn "15 false-intimacy opener"   "here'?s the thing"

# --- densities, measured on the author's prose only ---
dashes=$(grep -o -- '—' "$prose" | wc -l | tr -d ' ')
words=$(wc -w < "$prose" | tr -d ' ')
weak=$(grep -oEi "\b(is|are|was|were|has|have|provides|there (is|are))\b" "$prose" | wc -l | tr -d ' ')
if [[ "$words" -gt 0 ]]; then
  density=$(( weak * 100 / words ))
  echo "INFO weak-verb density: $weak in $words words (${density} per 100)"
  if [[ "$density" -gt 6 ]]; then
    echo "WARN [14 weak-verb density] over 6 per 100 — tighten with concrete verbs"
  fi
  dash_density=$(( dashes * 100 / words ))
  echo "INFO em-dash density: $dashes in $words words (${dash_density} per 100)"
  if [[ "$dash_density" -gt 3 ]]; then
    echo "WARN [16 em-dash density] over 3 per 100 — swap some for commas, parentheses, or a full stop"
  fi
fi

if [[ "$fail" -eq 0 ]]; then
  echo "PASS — no hard LLM-tic rules fired"
fi
exit "$fail"
