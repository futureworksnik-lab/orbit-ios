# CP-2 Summary — CI/CD Pipeline

## Built

- `.swiftlint.yml`, `.swiftformat` (WIP-2.A).
- `.github/workflows/ci.yml`: build+test, SwiftLint, SwiftFormat (lint-only), SPM dependency-pin
  audit, banned-word gate — all in one `Build, Test, Lint` job (WIP-2.B).
- Dynamic simulator-destination selection, replacing a hardcoded `name=iPhone 16` that was both
  ambiguous (present across 5 iOS runtimes on the macos-15 runner pool) and subject to a
  cold-runner race where CoreSimulatorService hadn't enumerated any simulators yet (WIP-2.C).

## Gate verification evidence (WIP-2.C / WIP-2.D)

Both throwaway branches' original proofs (from 2026-08-07) were invalid or stale: the
banned-word-gate branch's one CI run died at the old destination bug before ever reaching the
banned-word step, and the format-gate branch's proof predated the destination fix entirely. Both
were rebased/merged onto the fixed `main` and re-run for a trustworthy result.

**Format gate (WIP-2.C)** — PR #4, `test/ci-format-gate`:
- Violation (mis-indented `Text("Orbit")` in `ContentView.swift`) → Build & test passed, CI failed
  specifically at SwiftFormat: `Orbit/ContentView.swift:12:1: error: (indent) Indent code in
  accordance with the scope level.`
  Run: https://github.com/futureworksnik-lab/orbit-ios/actions/runs/31271889834
- Reverted, branch deleted, PR closed without merge.

**Banned-word gate (WIP-2.D)** — PR #2, `test/ci-banned-word-gate`:
- Violation (`// anonymous placeholder note for gate testing`) → Build & test passed, CI failed at
  the banned-word gate: `##[error]Banned vocabulary (PRD Sec.3): // anonymous placeholder note for
  gate testing`.
  Run: https://github.com/futureworksnik-lab/orbit-ios/actions/runs/31272737337
- `orbit-vocabulary-ok: <reason>` escape hatch added above the same line → CI passed end-to-end,
  including the banned-word gate step.
  Run: https://github.com/futureworksnik-lab/orbit-ios/actions/runs/31273511316
- Confirmed locally that a bare `orbit-vocabulary-ok:` with no reason string does **not** escape
  (script requires a non-empty reason) — `check-banned-words.sh` exits 1 as expected.
- Reverted, branch deleted, PR closed without merge.

**Destination fix itself (WIP-2.C)** — PR #3, `feat/cp-2-ci-fix`, merged via squash into `main`:
- Real, non-throwaway PR required to go green end-to-end per CP-2's own test.
- First run failed code review (3 findings: dropped `|| true` tolerance on the warm-up calls, a
  jq `null`-iteration crash on the fully-cold-runner case, lexicographic instead of numeric
  runtime-version sorting) — all three fixed in a follow-up commit before merge.
- Final run green end-to-end: https://github.com/futureworksnik-lab/orbit-ios/actions/runs/31270073390
