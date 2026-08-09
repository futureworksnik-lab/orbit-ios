# Orbit — Build CLAUDE.md (prod/ORBIT)

This is the TRD_D1-CP-1-style "brain" for the actual Xcode project. Workspace-level context (personas, banned vocabulary, archive rules, MCP servers) lives one level up in the root `CLAUDE.md` — not duplicated here. This file is tracked by this repo's own git history; update it after every checkpoint.

## active: CP-4 fully built — WIP-4.A, WIP-4.B, and WIP-4.C all complete (branch `feat/cp-4-core-components`, commits `5e8a280` (4.A), `6ad7a38` (4.B), `7c82f89` (4.C dependency), `b6efbf8` (4.C components + tests), not yet merged/reviewed). All ten CP-4 core components exist with snapshot coverage; `trd-compliance-reviewer` sign-off and merge to `main` are the only remaining steps before CP-4 is considered done.

WIP-4.A built `Orbit/DesignSystem/Components/{OrbitButton,LoadingButton,OrbitTextField,OTPBoxField}.swift` on top of CP-3 tokens: `OrbitButton` (primary/secondary/destructive, pressed/disabled/loading via a custom `ButtonStyle` + pure `OrbitButtonAppearance.resolve()`), `LoadingButton` (thin async wrapper), `OrbitTextField` (pure `borderColor()` precedence: error > focused > default), `OTPBoxField` (single hidden autofill-driving `TextField` behind a visible box `HStack`, per Apple's `.textContentType(.oneTimeCode)` pattern — not `length` separate fields). Both pure functions were written test-first (`OrbitTests/DesignSystem/Components/{OrbitButtonAppearanceTests,OrbitTextFieldTests}.swift`, 13 `@Test`s, confirmed red before implementation, green after).

WIP-4.B built `Orbit/DesignSystem/Components/{OrbitCard,ChipChrome,OpenerChip,VibeTag,Avatar}.swift`: `OrbitCard` (generic pure layout container — `.surface1`/`Radius.card`/`.e2` shadow/`.borderHairline`, no baked-in tap gesture, caller wraps in `Button` if it wants one); `ChipChrome.swift` (file-scoped shared chip chrome — `ChipChromeAppearance.resolve(isSelected:)` pure function + `ChipChromeLabel` view — used by both chip components but not part of either's public API, per the founder-confirmed decision that OpenerChip/VibeTag stay two separate types rather than one mode-enum component); `OpenerChip` (always-interactive single-select picker chip, fires `Haptics.chipToggle()` unconditionally on tap); `VibeTag` (`onTap == nil` renders a static undecorated display badge for discovery cards — no `Button`, no haptic; `onTap != nil` renders an interactive picker item, same haptic as `OpenerChip`); `Avatar` (image-or-initials-fallback circle via `Radius.avatar = .infinity`, optional bottom-trailing mutual-path glyph badge sized via pure `AvatarGlyphAppearance.badgeDiameter(avatarSize:) = avatarSize / 3`, `person.2.fill` SF Symbol, `.borderHairline` ring). No Kingfisher wiring yet (out of scope — `Avatar.image` is a plain SwiftUI `Image?`, a later checkpoint composes it around whatever loader lands then). Both new pure functions have Swift Testing coverage (`OrbitTests/DesignSystem/Components/{ChipChromeAppearanceTests,AvatarGlyphAppearanceTests}.swift`, 4 `@Test`s). All token names in the WIP-4.B task spec (`Radius.chip`/`Radius.card`/`Radius.avatar`/`orbitLabelStyle()`/`Haptics.chipToggle()`) matched the actual token API exactly — no corrections needed.

WIP-4.C built the final two core components and full snapshot coverage. `Orbit/DesignSystem/Components/EmptyStateView.swift` (icon + title + message + optional single CTA — the CTA renders as a plain `OrbitButton` so its haptic is inherited for free, nothing new wired; icon point size reuses `TypeSpec.h1.size` (34pt) since §4.2/§4.3 have no dedicated icon-size token — flagged as a token-layer gap, not silently absorbed) and `Orbit/DesignSystem/Components/SkeletonView.swift` (`.surface2` block with an animated diagonal shimmer sweep, duration `MotionSpec.standardDuration * 4` — a named constant scaled, not a new bare literal, mirroring how CP-3 documented `Radius.avatar = .infinity`; no haptic, display-only). Added `swift-snapshot-testing` 1.19.4 as a new `XCRemoteSwiftPackageReference`/`XCSwiftPackageProductDependency` in `project.pbxproj`, wired only into `OrbitTests`' `packageProductDependencies` (confirmed the shipping `Orbit` app target is untouched) — confirmed the pinned version's README documents `import Testing`/`@Test` support directly, not just XCTest. Added `OrbitTests/SnapshotTests/` — one file per CP-4 component (all ten: the 8 from 4.A/4.B plus these 2), Swift Testing style, `perceptualPrecision: 0.98` on every `assertSnapshot` call (CI's dynamically-resolved simulator makes pixel-exact diffing unreliable across OS point releases), reference PNGs recorded once then committed. Two documented tooling seams, mirroring CP-3's Haptics-testing-gap precedent: `OrbitTextField`/`OTPBoxField` skip the `@FocusState`-driven focused look (no reliable first-responder chain in off-screen snapshot rendering) and `OrbitButton`'s pressed states are rendered via a static view built from `OrbitButtonAppearance.resolve(isPressed: true, ...)`'s own output (`ButtonStyleConfiguration` has no public initializer, so no test-only parameter was added to `OrbitButton`'s public API to fake it). `SnapshotTestSupport.swift` is a test-only harness fixing a 400pt host width + `.fixedSize(vertical: true)` to work around a `UIHostingController`/`.sizeThatFits` multi-line-`Text` measurement quirk — not a change to any of the 10 components themselves.

Full suite green (81 passed / 0 failed / 0 skipped per `test_sim`, incl. all new snapshot tests and UI launch tests), `swiftlint lint --strict` and `swiftformat --lint .` both clean (one `trailing_closure` violation in `EmptyStateView`'s `#Preview` and its own snapshot test, fixed by switching `action: {}` to trailing-closure syntax), banned-vocabulary grep clean (only false-positive substring hits on "single CTA"/"single-line"/"single frame," not the banned relationship-status sense). `git diff --stat` against the pre-4.C tree confirms only `OrbitTests` and new component/test files changed — the shipping `Orbit` app target's sources and `packageProductDependencies` are untouched. `trd-compliance-reviewer` sign-off and merge to `main` still needed before CP-4 overall is considered done.

Current true state, confirmed by direct inspection — trust this over any stale prose below it:
- CP-1 (Repo, Xcode project, SPM, CLAUDE.md) is complete.
- SwiftData fully removed (Item.swift deleted, `ORBITApp.swift`/`ContentView.swift` stripped of `@Model`/`ModelContainer`/`@Query`); `ContentView.swift` is a minimal `Text("Orbit")` placeholder pending a later checkpoint.
- Project and both targets renamed `ORBIT` → `Orbit` (app target `Orbit`, test targets `OrbitTests`/`OrbitUITests`); on-disk casing verified via `ls` (not just `git status`, which can hide case-only mismatches on APFS).
- Bundle ids: `com.orbit.app` (app), `com.orbit.app.tests`, `com.orbit.app.uitests`.
- `IPHONEOS_DEPLOYMENT_TARGET = 17.0` (was 26.5) across project + target Debug/Release configs.
- SPM deps resolved and linked natively in `project.pbxproj` (no `Package.swift` — see note below): `supabase-swift` (`Supabase` product, upToNextMajorVersion from 2.54.1) and `KeychainAccess` (upToNextMajorVersion from 4.2.2), wired only into the `Orbit` app target's `packageProductDependencies`. `Package.resolved` is committed at `Orbit.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`.
- Folder skeleton present under `Orbit/`: `App/` (holds `OrbitApp.swift`), `Features/`, `Core/`, `DesignSystem/`, `Resources/` (each with a `.gitkeep`, excluded from the app target's resource copy phase via a `PBXFileSystemSynchronizedBuildFileExceptionSet` — needed because the project uses Xcode 16's folder-sync groups, which would otherwise try to copy every loose `.gitkeep` as a bundle resource and collide on the flattened output path). `ContentView.swift` stays at `Orbit/` root (throwaway, replaced by a later checkpoint). `docs/checkpoints/` also scaffolded with a `.gitkeep`.
- `.gitignore` added at `prod/ORBIT/.gitignore` (Xcode/SPM/secrets patterns; `Package.resolved` deliberately NOT ignored).
- **No `Package.swift` exists, by design** — this is an `.xcodeproj`-based app, not a Swift package. SPM dependencies live natively in `project.pbxproj`'s `XCRemoteSwiftPackageReference`/`XCSwiftPackageProductDependency` sections, not a standalone manifest. Do not go looking for one or create a stub.
- Design tokens exist under `Orbit/DesignSystem/Tokens/`: `Color+Tokens.swift` (14 §4.1 colors + `rgba255()` readback helper), `Typography.swift` (`TypeSpec` enum as source of truth + `orbit`-prefixed `Font` statics, since SwiftUI's own `Font` already declares `.title`/`.body`/`.callout`/`.footnote`/`.caption`), `Spacing.swift`, `Radius.swift` (`avatar = .infinity`), `Shadow.swift` (`OrbitShadow`, not `ShadowStyle` — collides with `SwiftUI.ShadowStyle`), `Motion.swift`, `Haptics.swift`. `Orbit/DesignSystem/TokenPreview.swift` is a `#Preview`-only swatch sheet, not wired into any shipped screen. `.swiftlint.yml` gained `trailing_comma.mandatory_comma: true` (to match `.swiftformat`'s `--commas always`), a narrow `large_tuple` threshold raise to accommodate `rgba255()`'s 4-member tuple, and `identifier_name.min_length` lowered to 1 with a short-name `excluded` list for design-token vocabulary (`r`/`g`/`b`/`a`/`x`/`y`/`h1`-`h3`/`s4`/`s8`/`e0`-`e3`).
- Git: branch `main`, remote `origin` → `https://github.com/futureworksnik-lab/orbit-ios` (private repo, pushed).

**Update this line after every CP/WIP commit** (per `TRD_PARENT.md` §11 handoff discipline) so a new session can resume without re-deriving state.

## Stack decisions (TRD_PARENT §2, D1.3)

- Swift 5.9+ (Swift 6 ready), SwiftUI, **iOS 17.0 min**, bundle id `com.orbit.app`.
- State: `@Observable` (Observation framework) + MVVM + lightweight Coordinator. **SwiftData is explicitly excluded** (Assumption 8 — background `ModelActor`→`@Query` propagation is unreliable through iOS 26). Persistence is `Codable` JSON snapshots on disk instead.
- Navigation: `NavigationStack` + typed routes; modals via `.sheet`/`.fullScreenCover`.
- Networking: `supabase-swift` over native `URLSession` async/await (no Alamofire).
- Images: Kingfisher (`KFImage`), aggressive disk cache.
- Animation: Lottie (`lottie-spm`) for the reveal/aha moment; native SwiftUI springs elsewhere.
- Keychain: KeychainAccess, for session tokens only.
- Lint/format: SwiftLint + SwiftFormat, installed locally via Homebrew; configs (`.swiftlint.yml`/`.swiftformat`) land at CP-2, at which point `.claude/hooks/swift-autoformat-lint.sh` becomes fully functional.

## Conventions

- Types `PascalCase`; files match their primary type; ViewModels suffixed `ViewModel`.
- One feature = one `Features/<Name>/` directory (enables parallel, non-conflicting work across checkpoints).
- Commit format: `[WIP-N.X] short description` for sub-checkpoints, `[CP-N] NAME complete` when a full checkpoint's test passes.
- Banned vocabulary and the ILLUSTRATIVE/REFERENCE code-provenance rule apply here exactly as stated in the root `CLAUDE.md` and `.claude/rules/swift-conventions.md` — not restated in full here to avoid drift between two copies.

## Checkpoint map (by daughter TRD — confirm exact ranges against each doc's own header, they may shift as the TRDs are revised)

| Daughter | Path | Covers |
|---|---|---|
| D1 — Foundation | `docs/trd/TRD_D1_Foundation.md` | Repo/Xcode bootstrap, CI/CD, design tokens, 3-tab shell, `.edu` OTP auth + campus gate |
| D2 — Backend | `docs/trd/TRD_D2_Backend.md` | Supabase schema, RLS, Edge Functions, graph compute, Realtime Broadcast |
| D3 — Frontend | `docs/trd/TRD_D3_Frontend.md` | SwiftUI screens built on D1's design system |
| D4 — Growth & Security | `docs/trd/TRD_D4_GrowthSecurity.md` | Super-connector seeding, abuse/safety mechanics |
| D5 — Launch & Deploy | `docs/trd/TRD_D5_LaunchDeploy.md` | TestFlight, App Store submission, cost-gate provisioning |

Use the `/trd-checkpoint` skill to resume: it reads the `active:` line above, pulls the matching `### CP-N` block, and presents the full contract before implementation starts.

## Cross-daughter dependency note

Some checkpoints declare a `→ Requires:` on a *later* daughter (e.g. D1 CP-6's auth wiring needs D2 CP-7's Supabase anon key). If building serially, do CP-7 immediately after CP-5, then CP-6 — this is a documented dependency in the TRD, not a contradiction to "fix."
