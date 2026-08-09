# CP-3 Summary — Design-System Tokens

## Built

`Orbit/DesignSystem/Tokens/{Color+Tokens,Typography,Spacing,Radius,Shadow,Motion,Haptics}.swift`
— the full token set from `TRD_PARENT.md` §4, plus `Orbit/DesignSystem/TokenPreview.swift`
(`#Preview`-only swatch sheet, not wired into any shipped screen). Matching Swift Testing suites
under `OrbitTests/DesignSystem/Tokens/` for every category except Haptics (see Debt below).

- **Colors (§4.1)** — 14 `Color` statics built from a non-failable `init(hex: UInt32, opacity:)`
  (bit-shift decomposition, not a failable String-parsing init — avoids tripping the
  `force_unwrapping` opt-in SwiftLint rule). A `rgba255()` readback helper lets tests and the
  preview assert/label the *rendered* channel values instead of hand-transcribing hex a second
  time, so they can't silently drift from the source of truth.
- **Typography (§4.2)** — `TypeSpec` enum holds the raw `(size, weight)` pairs per style as the
  real source of truth; `Font` extension derives the actual `Font` values from it.
- **Spacing/Radius/Shadow/Motion/Haptics (§4.3)** — `Spacing`/`Radius` as plain `CGFloat` enums,
  `OrbitShadow` struct + `View.orbitShadow(_:)` modifier, `MotionSpec` enum + `Animation`
  extension, `Haptics` enum wrapping the three UIKit feedback generators with both raw
  (`impact(_:)`) and purpose-named (`selectTap()`, `acceptReveal()`, etc.) methods matching
  §4.3's haptic map verbatim.

## Decisions

- **`Font` statics are `orbit`-prefixed** (`orbitH1`…`orbitLabel`), not bare `H1`/`Body`/etc.
  SwiftUI's own `Font` already declares `.title`/`.body`/`.callout`/`.footnote`/`.caption` as
  Dynamic Type statics; a same-named redeclaration in an extension causes ambiguous-use compile
  errors at every call site using either. Applied consistently to all 11 styles for naming
  consistency, not just the colliding five.
- **Shadow struct is named `OrbitShadow`, not `ShadowStyle`** — `SwiftUI.ShadowStyle` is a real
  public iOS-17 type (`ShapeStyle.shadow(_:)`); reusing the name collides the same way.
- **Typography implemented as fixed `Font.system(size:weight:)`, not Dynamic-Type-scaled.**
  §4.2's table gives literal point sizes/weights with no Dynamic Type text-style mapping anywhere
  in `TRD_PARENT.md`, and §11 rule 7 requires matching design tokens exactly. Flagging this as a
  **named, deliberate deferral, not an oversight**: fixed-size fonts don't respond to the user's
  system text-size setting, which is a real Apple accessibility expectation and a plausible App
  Review nitpick later. Revisit if a future checkpoint or App Review feedback requires Dynamic
  Type support — nothing in §4 authorizes it now, and CP-3 is a token-fidelity checkpoint, not an
  accessibility checkpoint.
- **`avatar` radius token is `CGFloat.infinity`.** §4.3 specifies "avatar circle" with no fixed
  pt value; `.infinity` is the correct SwiftUI idiom (`RoundedRectangle`/`.cornerRadius` clamp to
  a true circle on any square frame) and gives every §4.3 bullet a real symbol rather than
  silently dropping the one non-numeric entry.
- **`Font`/`Animation` are opaque SwiftUI types with no public size/weight/duration accessor** —
  tests assert against the raw `TypeSpec`/`MotionSpec` enums (the actual source of truth), not
  against the derived `Font`/`Animation` values, which can't be introspected at all.
- **No `HapticsTests.swift`.** UIKit feedback generators (`UIImpactFeedbackGenerator` etc.)
  expose no observable "did it fire" state — no delegate, no return value, no completion — and
  Simulator hardware produces no haptic output regardless. A test that only calls the method and
  asserts no-throw would test compilation, not correctness, and would be false confidence. The
  checkpoint's own stated verification (tap the Preview button, ideally on a physical device) is
  the correct substitute; independent build/test verification confirmed the wiring compiles and
  the tap gesture correctly calls `Haptics.selectTap()` → `.impact(.light)`.
- **`.swiftlint.yml` changes** (outside CP-3's original "Files:" list, required to keep lint
  strict-clean against spec-mandated shapes rather than routing around a violation):
  `trailing_comma.mandatory_comma: true` (aligns with `.swiftformat`'s `--commas always`, which
  was already latently in conflict — this is the first checkpoint to write a multi-line array
  literal); `large_tuple` threshold raised to warning 4/error 5, scoped to accommodate
  `rgba255()`'s spec-mandated 4-member tuple; `identifier_name.excluded` list added for the
  design-token domain's legitimately short names (`r`/`g`/`b`/`a`/`x`/`y`/`h1`-`h3`/`s4`/`s8`/
  `e0`-`e3`). An initial version of this change also lowered `identifier_name.min_length`
  project-wide to 1 — `trd-compliance-reviewer` correctly flagged this as broader than necessary,
  since it silently disabled the short-identifier check for *all* future code (including later
  checkpoints' business logic), when the `excluded` list alone already whitelists the specific
  names by exact match regardless of length. Reverted `min_length` to SwiftLint's default;
  re-verified 0 lint violations with the narrower fix.

## Debt / follow-ups

- Dynamic Type / accessibility text scaling is not implemented (see Decisions above) — deferred,
  not forgotten, pending a future checkpoint or explicit product decision.
- Haptic *behavior* (which feedback style/type each purpose-named method actually invokes) is
  verified by code review and manual on-device tap, not by an automated spy-based test, since
  `Haptics.swift` calls the UIKit generators directly rather than through an injectable seam.
  Non-blocking for a token checkpoint; worth an injectable seam later only if haptic-dispatch
  logic grows more complex than direct passthrough.

## Security

Pure UI/token layer — no secrets, no network, no user input, no persistence. `.gitignore` intact
(unchanged this checkpoint). N/A for the remaining points of the 12-point audit.

## Verification

- Independently re-run (not just the implementer's self-report): `build_sim` → SUCCEEDED, 0
  warnings/errors. `test_sim` (full `OrbitTests` + `OrbitUITests`) → 47/47 passed, 0 failed.
  `swiftlint lint --strict` → 0 violations in 19 files. `swiftformat --lint .` → 0/19 files
  require formatting.
- `trd-compliance-reviewer` subagent ran against the full diff: PASS on TRD §4 value fidelity
  (every hex/size/weight/spacing/radius/shadow/motion/haptic value spot-checked against the
  table), PASS on banned vocabulary, PASS on code-provenance (greenfield, no TRD snippet lifted),
  PASS on no-stubs/app_config mandate, PASS on Files-list completeness. One finding (the
  `identifier_name.min_length` overreach above) — fixed in-session, re-verified clean.
- Manual preview render on iPhone 17 simulator confirmed color swatches match §4.1 hexes
  (labeled from `rgba255()` readback) and the layout/motion sections satisfy WIP-3.B/3.C's
  literal verify lines.

## WIP commits

`[WIP-3.A]` (038da92) — Color + typography tokens.
`[WIP-3.B]` (e13ec0b) — Spacing, radius, shadow tokens.
`[WIP-3.C]` (12a151d) — Motion springs + Haptics helper.
`341e296` — `.swiftlint.yml` fix per compliance review (folded into WIP-3.C's scope, since it
corrects that same commit's config change rather than opening a new WIP).
This checkpoint closes with the `[CP-3]` commit below.
