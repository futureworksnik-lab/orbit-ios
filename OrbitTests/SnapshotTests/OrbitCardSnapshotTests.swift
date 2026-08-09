//
//  OrbitCardSnapshotTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — snapshot coverage for OrbitCard (WIP-4.B). Pure layout container with no
//  interaction state of its own, so one representative-content snapshot is enough.
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Orbit

@MainActor
struct OrbitCardSnapshotTests {
    @Test func sampleContent() {
        let view = snapshotHost {
            OrbitCard {
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text("Coffee with Priya")
                        .font(.orbitTitle)
                        .foregroundStyle(Color.textPrimary)
                    Text("One hop away — mutual connection through Sam")
                        .font(.orbitBody)
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }
}
