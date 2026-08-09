//
//  VibeTagSnapshotTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — snapshot coverage for VibeTag (WIP-4.B). Covers both of its modes: the
//  interactive picker item (`onTap != nil`) and the static, undecorated display badge
//  (`onTap == nil`).
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Orbit

@MainActor
struct VibeTagSnapshotTests {
    @Test func unselectedPicker() {
        let view = snapshotHost { VibeTag(text: "Night owl", isSelected: false) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func selectedPicker() {
        let view = snapshotHost { VibeTag(text: "Night owl", isSelected: true) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func staticDisplay() {
        let view = snapshotHost { VibeTag(text: "Night owl") }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }
}
