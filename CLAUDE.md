# Orbit — Build CLAUDE.md (prod/ORBIT)

This is the TRD_D1-CP-1-style "brain" for the actual Xcode project. Workspace-level context (personas, banned vocabulary, archive rules, MCP servers) lives one level up in the root `CLAUDE.md` — not duplicated here. This file is tracked by this repo's own git history; update it after every checkpoint.

## active: CP-2 complete — CI/CD pipeline (build+test+lint+format+audit+banned-word gate), branch protection on main, repo public. Next: CP-3 (design-system tokens).

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
- No design tokens yet (design-system work starts in a later D1/D3 checkpoint).
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
