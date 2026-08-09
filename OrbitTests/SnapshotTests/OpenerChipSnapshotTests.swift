//
//  OpenerChipSnapshotTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — snapshot coverage for OpenerChip (WIP-4.B).
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Orbit

@MainActor
struct OpenerChipSnapshotTests {
    @Test func unselected() {
        let view = snapshotHost { OpenerChip(text: "Coffee run?", isSelected: false) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }

    @Test func selected() {
        let view = snapshotHost { OpenerChip(text: "Coffee run?", isSelected: true) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }
}
