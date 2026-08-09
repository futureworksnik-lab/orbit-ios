//
//  SkeletonViewSnapshotTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — snapshot coverage for SkeletonView (WIP-4.C). One snapshot is enough: the
//  shimmer is a looping animation, and snapshot testing captures one frame of it, not the
//  animation over time.
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Orbit

@MainActor
struct SkeletonViewSnapshotTests {
    @Test func restFrame() {
        let view = snapshotHost { SkeletonView(height: 96) }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }
}
