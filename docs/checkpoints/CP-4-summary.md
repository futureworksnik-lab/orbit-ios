# CP-4 Summary — Core Components

## Built

`Orbit/DesignSystem/Components/{OrbitButton,LoadingButton,OrbitTextField,OTPBoxField,OrbitCard,
ChipChrome,OpenerChip,VibeTag,Avatar,EmptyStateView,SkeletonView}.swift` — the full CP-4 component
set (9 named deliverables plus the shared `ChipChrome` visual helper), built entirely on CP-3's
token layer. Full Swift Testing coverage for every pure token-resolution function, plus a
snapshot-test suite (`OrbitTests/SnapshotTests/`) covering every reachable state per component.

- **OrbitButton / LoadingButton** — primary/secondary/destructive kinds; pressed via a custom
  `ButtonStyle` reading `configuration.isPressed`; disabled via native `.disabled(_:)`/
  `@Environment(\.isEnabled)`; loading via an `isLoading: Bool` (the one state SwiftUI has no
  native concept for). Token resolution extracted into a pure `OrbitButtonAppearance.resolve()`,
  test-first. `LoadingButton` is a thin `async` wrapper delegating all visuals to `OrbitButton`.
- **OrbitTextField / OTPBoxField** — error/focused/default precedence via a pure
  `borderColor(errorMessage:isFocused:)` function (error wins over focused wins over default).
  `OTPBoxField` uses one hidden autofill-driving `TextField` behind a visible box `HStack` (per
  Apple's `.textContentType(.oneTimeCode)` pattern) rather than N separate fields, which would
  break autofill.
- **OrbitCard** — generic pure layout container, no baked-in tap gesture.
- **OpenerChip / VibeTag** — two separate types (founder-confirmed decision, not one component
  with a mode enum — see Decisions), sharing `ChipChrome.swift`'s private
  `ChipChromeAppearance.resolve(isSelected:)` + `ChipChromeLabel`. `OpenerChip` is always
  interactive; `VibeTag`'s `onTap == nil` renders a static display badge, `onTap != nil` a picker
  item.
- **Avatar** — image-or-initials-fallback circle (`Radius.avatar = .infinity`), optional
  bottom-trailing mutual-path glyph badge sized via a pure `AvatarGlyphAppearance.badgeDiameter()`
  (proportional to avatar size, never an absolute pixel value). No network image loading —
  Kingfisher isn't wired as a dependency yet; `Avatar.image` is a plain `Image?`.
- **EmptyStateView / SkeletonView** — icon+title+message+optional CTA (CTA renders as a plain
  `OrbitButton`, haptic inherited for free); shimmer loading placeholder with a documented
  Reduce-Motion accommodation (see Decisions).

## Decisions

- **`OpenerChip`/`VibeTag` are two separate component files**, not one component with a
  `mode: .opener | .vibe` enum. CP-4's contract lists them jointly ("OpenerChip/VibeTag"), but D3
  uses them with genuinely different semantics — `OpenerChip` is always an interactive
  single-select-group item, `VibeTag` is either a multi-select picker item *or* a static read-only
  display badge on discovery cards. Confirmed with the founder before implementation (a mode-enum
  component would have reintroduced the config-flag smell ponytail discipline warns against).
- **`LoadingButton` is a thin `async` wrapper around `OrbitButton`**, not a separately-styled
  component. Both are listed as CP-4 contract bullets, but their state matrices (primary/
  secondary/destructive × pressed/disabled/loading) fully overlap; a second component reimplementing
  that chrome would duplicate `OrbitButton`'s visuals for no reason. Confirmed with the founder.
- **No `errorPressed` color token exists in CP-3.** `OrbitButton`'s destructive-pressed state
  carries feedback via the shadow drop alone (same pattern as secondary), rather than inventing an
  opacity literal or a new token unilaterally mid-checkpoint.
- **Two components reuse an existing numeric token for a value §4.2/§4.3 doesn't name directly**,
  rather than introducing a bare literal: `EmptyStateView`'s icon size reuses `TypeSpec.h1.size`
  (34pt — no dedicated icon-size token exists), and `SkeletonView`'s shimmer duration reuses
  `MotionSpec.standardDuration * 4` (a named constant, scaled). Both are commented in-source as
  deliberate token reuse, mirroring how CP-3 documented its `Radius.avatar = .infinity`
  interpretation.
- **Pressed-button snapshot testing goes through the pure `OrbitButtonAppearance.resolve()`
  function directly**, rendering a static view from its output, rather than driving a live
  `ButtonStyle` — `ButtonStyleConfiguration` has no public initializer, so a "pressed" one can't be
  constructed in a test. No test-only parameter was added to `OrbitButton`'s public API to fake
  this.
- **`@FocusState`-driven `focused` states are not snapshot-tested** (`OrbitTextField`,
  `OTPBoxField`) — off-screen snapshot rendering has no reliable first-responder chain. Documented
  as a manual-QA gap in each snapshot test file's header comment, mirroring CP-3's own documented
  Haptics-testing gap.
- **`swift-snapshot-testing` 1.19.4 added as a brand-new SPM dependency**, wired only into
  `OrbitTests`'s `packageProductDependencies` in `project.pbxproj` (never the shipping `Orbit` app
  target), following the same native-pbxproj pattern CP-1 used for `supabase-swift`/
  `KeychainAccess`. `perceptualPrecision: 0.98` and `traits: .init(displayScale: 3)` used on every
  `assertSnapshot` call (see **CI pipeline change** below for why the latter was needed).
- **CI pipeline change — `.github/workflows/ci.yml` no longer selects its iOS simulator
  dynamically.** CP-2 deliberately chose "pick the highest-available-OS iPhone" to avoid a
  cold-runner race (a simulator/runtime not pre-installed, forcing a slow on-demand download).
  CP-4 is the first checkpoint to add pixel-snapshot tests, and that dynamic selection turned out
  to be fundamentally incompatible with them — three real CI-only failures surfaced across PR #8's
  first three runs, each root-caused with actual evidence (not guessed) before being fixed:
  1. **Window-server hang.** `simctl boot` starts the simulator process but not its window server;
     the first SwiftUI-view snapshot render (`UIHostingController`) hung until xcodebuild's ~300s
     test watchdog killed the whole run, bulk-failing all 32 snapshot tests with a synthetic
     placeholder duration. Fixed by adding `open -a Simulator` + a settle delay after boot.
  2. **Display-scale mismatch.** Reference PNGs were recorded locally on iPhone 17 (3x); CI's
     dynamic selection resolved to iPhone SE (3rd generation) (2x). `SnapshotTesting`'s `.image()`
     strategy renders at `traits.displayScale`, which defaults to the host simulator's native
     scale — different pixel dimensions is a hard mismatch no `perceptualPrecision` can absorb.
     Confirmed by reading `SnapshotTesting`'s own `SwiftUIView.swift` source. Fixed by pinning
     `traits: .init(displayScale: 3)` on all 32 `assertSnapshot` calls.
  3. **Cross-OS-point-release font rendering.** Even with scale fixed, text/SF-Symbol-bearing
     components still failed while the one component with no text (`SkeletonView`) passed — CI's
     dynamic selection had resolved to iOS 26.2 that run, three point releases behind the iOS 26.5
     used to record references locally. Font hinting/AA differences between point releases exceed
     `perceptualPrecision: 0.98`.
  **Founder decision** (offered three options: pin a fixed simulator + re-record, loosen precision
  further, or drop snapshot tests from CI): pin CI to a confirmed-installed **iPhone 16 / iOS
  26.2**, with a documented, warned fallback to the old dynamic scan if that combo ever disappears
  from the runner image. No local dev machine had iOS 26.2 installed, so a temporary
  `record-cp4-snapshots` CI job (added, used once, then removed) generated CI-native reference
  PNGs against that exact simulator; all 32 references were replaced with its output. **Known,
  accepted consequence:** a dev machine on a different iOS runtime (this session's machine: 26.5)
  will see occasional near-miss snapshot failures on text-heavy views even with no real
  regression — confirmed with `EmptyStateViewSnapshotTests.withoutCTA` at 0.976 vs the 0.98
  threshold, locally, while CI (26.2) passes clean. **CI's pinned simulator is now the
  authoritative source of truth for this suite, not whatever runtime a given dev machine has.**
- **HIG touch-target and Reduce-Motion fixes** (found by `/impeccable critique`, scoped to
  `reference/ios.md`'s iOS checklist): `OpenerChip`/`VibeTag`'s interactive tap area was ~64pt
  tall (label line height + `Spacing.s8` vertical padding), under the 44×44pt HIG floor. Fixed by
  growing the `Button`'s hit area to `Spacing.s48` (an existing token, not a new literal) without
  changing the chip's compact visual size; `VibeTag`'s non-interactive static-display branch is
  untouched. `SkeletonView`'s shimmer ignored Reduce Motion — now reads
  `@Environment(\.accessibilityReduceMotion)` and holds the gradient static instead of sweeping it
  when enabled.

## Debt / follow-ups

- Dynamic Type (fixed-size fonts) and raw-hex-vs-semantic-system colors are pre-existing CP-3
  decisions, inherited by every CP-4 component — already tracked as debt in `CP-3-summary.md`, not
  relitigated here.
- `@FocusState` focused-state snapshot coverage (see Decisions) — manual-QA gap, not automated.
- **CI's pinned simulator (iPhone 16 / iOS 26.2) will eventually age out** of the `macos-15`
  runner image as GitHub updates it. The fallback in `ci.yml`'s "Select simulator destination"
  step prints a `::warning::` and reverts to the old dynamic scan rather than hard-failing, but
  that fallback reintroduces exactly the flakiness this checkpoint fixed. Treat that warning as a
  prompt to re-pin (and re-record all 32 references) against whatever the runner actually has,
  not something to ignore.
- A dev machine without iOS 26.2 installed (true of this session's machine) will see occasional
  near-miss local snapshot failures with no real regression — see the CI pipeline change note
  above. Not a bug to chase; CI is authoritative for this suite.
- `OrbitButton` unconditionally fires `Haptics.selectTap()` on every tap with no override hook. A
  future D3 screen building a "Send Intro" button on top of `OrbitButton` will need to layer its
  own `Haptics.sendIntro()` call on top (complementary light-tap-ack + heavier-result-ack, not
  duplicative) — flagged during compliance review as a forward-looking note for D3, not a CP-4
  defect.

## Security

Pure UI/component layer — no secrets, no network, no user input persistence beyond the caller's
own `@Binding`s. N/A for the remaining points of the audit.

## Verification

- Independently re-run after every fixup (not just the implementing subagents' self-reports):
  `build_sim` → SUCCEEDED, 0 warnings/errors throughout. `test_sim` locally → 81/81 passed on
  every run before the CI-pinning fix; 80/81 after (the one expected iOS-26.5-vs-26.2 near-miss,
  see CI pipeline change above). `swiftlint lint --strict` → 0 violations, 45 files.
  `swiftformat --lint .` → 0/45 files require formatting. `bash scripts/check-banned-words.sh`
  (the CI-authoritative gate) → exits 0.
- `trd-compliance-reviewer` ran twice: the first pass found everything else in the CP-4 contract
  passing but caught the branch failing the repo's real `scripts/check-banned-words.sh` (7 comments
  using "single" in its ordinary sense — same false-positive class CP-3 hit with "match"); a second,
  narrower confirmation pass verified the reword fix, re-ran build/test/lint, and confirmed no
  other regression — full PASS.
- `/impeccable critique` (iOS HIG scope, `reference/ios.md`) found the sub-44pt chip touch target
  and missing Reduce Motion handling — both fixed and re-verified in-session.
- **PR #8's actual CI took four pushes to go green**, all root-caused with real log evidence, not
  guessed: banned-word gate (compliance-review finding, fixed pre-merge), window-server hang,
  display-scale mismatch, cross-OS font rendering — see the CI pipeline change note above for the
  full story. Final CI run: green in 8m27s on `main` after squash-merge; `main` independently
  re-verified directly (build + lint + banned-words all clean; 80/81 local tests, the one expected
  near-miss).

## WIP commits

`[WIP-4.A]` (5e8a280) — Buttons + textfields.
`[WIP-4.B]` (6ad7a38) — Cards + chips + avatar.
`[WIP-4.C]` (7c82f89, b6efbf8) — swift-snapshot-testing dependency, EmptyStateView, SkeletonView,
snapshot tests.
`2c7c844` — HIG fixes (44pt chip touch targets, Reduce Motion) found by `/impeccable critique`.
`4a6b06c` — banned-word gate fix found by the first `trd-compliance-reviewer` pass.
`d5b2551` — CI window-server fix (`open -a Simulator`).
`eca503e` — pin `displayScale: 3` on all 32 snapshot assertions.
`a3544fa` — pin CI destination to iPhone 16/iOS 26.2, add temporary recording job.
`84224f3` — replace all 32 references with CI-native (iPhone 16/iOS 26.2) recordings, remove the
temporary recording job.
Several `docs:`/CLAUDE.md-sync commits along the way.
This checkpoint closes with the `[CP-4]` squash-merge commit `3a681d8` on PR #8, merged to `main`.
