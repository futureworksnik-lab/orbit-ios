//
//  SnapshotTestSupport.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — shared test-only harness for the CP-4 component snapshot suite. Not a
//  production type and not a design token: fixes a deterministic host width/background so every
//  snapshot renders identically regardless of `.sizeThatFits`'s ambiguity around components that
//  use `.frame(maxWidth: .infinity)`.
//
//  `.fixedSize(horizontal: false, vertical: true)` below is a test-harness-only workaround for a
//  `UIHostingController`/`.sizeThatFits` measurement quirk: without it, multi-line `Text` (e.g.
//  EmptyStateView's message, OrbitCard's subtitle) reports its unwrapped single-line intrinsic
//  width during the snapshot's sizing pass and renders truncated with an ellipsis even though the
//  final frame has room to wrap — confirmed by inspecting the first recorded reference PNGs. This
//  is purely a snapshot-measurement artifact, not a production layout bug: none of the 10
//  components themselves were changed to work around it.
//

import SwiftUI
@testable import Orbit

/// Wide enough to fit every CP-4 component's rest-state content without wrapping or clipping —
/// OTPBoxField's 6-box row (`6 * Spacing.s48 + 5 * Spacing.s8`) is the widest, at 328pt before
/// this host's own padding. A test-harness sizing constant, not a design token — CP-3's §4.3
/// grid has no "screen width" entry.
let snapshotHostWidth: CGFloat = 400

/// Wraps `content` in Orbit's standard dark canvas background at a fixed width, mirroring how
/// every CP-4 component's own `#Preview` already stages itself against `Color.bgSpace`.
@MainActor
func snapshotHost(@ViewBuilder _ content: () -> some View) -> some View {
    content()
        .padding(Spacing.s16)
        .frame(width: snapshotHostWidth)
        .fixedSize(horizontal: false, vertical: true)
        .background(Color.bgSpace)
}
