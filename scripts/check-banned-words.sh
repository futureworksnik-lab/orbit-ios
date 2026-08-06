#!/usr/bin/env bash
# scripts/check-banned-words.sh -- PRD Sec.3 List A/B banned-vocabulary gate.
# Adapted from docs/trd/TRD_D1_Foundation.md CP-2's own code block, which is
# unlabeled (= ILLUSTRATIVE per this repo's provenance convention) and has a
# real bug: an empty $TARGETS array makes grep read stdin instead of exiting,
# hanging CI indefinitely. Fixed below with an explicit empty-array guard.
# Written for bash 3.2 (macOS system default, and the GitHub Actions macos-15
# runner's /usr/bin/env bash) -- no `mapfile`/`readarray` (bash 4+ only).
# A second bug found while verifying this script by hand: git's DEFAULT
# pathspec matching does not treat `**` as "zero or more directories" the way
# shell globstar does -- `Orbit/**/*.swift` silently excludes files sitting
# directly in `Orbit/` (e.g. ContentView.swift), only matching subdirectories.
# The `:(glob)` pathspec magic switches to real fnmatch(FNM_PATHNAME) glob
# semantics, where `**` does include the zero-directory case. Verified via
# `git ls-files 'Orbit/**/*.swift'` vs `git ls-files ':(glob)Orbit/**/*.swift'`.
# A third bug found while verifying: bare alternatives with no word boundary
# false-positive on ordinary substrings -- "hot" inside "screenshot", "anon"
# inside "canonical". Wrapped in \b...\b below. Note this does not (and per
# design cannot) distinguish Foundation's `Date` type from the banned noun
# "date" -- a real `Date()` usage will still trip the gate and needs the
# documented `orbit-vocabulary-ok:` escape hatch, same as any other genuinely
# technical term (see PRD Sec.3 rationale for why exceptions must be explicit).
set -euo pipefail

LIST_A='\b(dating|date|matche?d?|matches|single|swipe|crush|hot|spark)\b'
LIST_B='\b(blind|anonymous|anon|mystery|mysterious|secretly?|hidden admirer|random(ly matched)?|stranger|unknown person|chat with anyone)\b'

TARGET_GLOBS=(
  ':(glob)Orbit/**/*.swift' ':(glob)OrbitTests/**/*.swift' ':(glob)OrbitUITests/**/*.swift'
  '*.strings' '*.stringsdict'
  ':(glob)supabase/functions/**/*.ts'
  ':(glob)fastlane/metadata/**/*.txt'
  'docs/launch/store-listing.md'
)
TARGETS=()
while IFS= read -r f; do
  TARGETS+=("$f")
done < <(git ls-files "${TARGET_GLOBS[@]}" 2>/dev/null)
if [ "${#TARGETS[@]}" -eq 0 ]; then
  echo "check-banned-words: no tracked target files yet -- nothing to scan."
  exit 0
fi

FAIL=0
for pattern in "$LIST_A" "$LIST_B"; do
  while IFS=: read -r file line content; do
    [ -z "${file:-}" ] && continue
    prev=$(sed -n "$((line-1))p" "$file" 2>/dev/null || true)
    if echo "$prev" | grep -qE 'orbit-vocabulary-ok: .+'; then
      continue
    fi
    echo "::error file=$file,line=$line::Banned vocabulary (PRD Sec.3): $content"
    FAIL=1
  done < <(grep -nEi "$pattern" "${TARGETS[@]}" /dev/null)
done
exit $FAIL
