//
//  EmptyStateViewSnapshotTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — snapshot coverage for EmptyStateView (WIP-4.C).
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Orbit

@MainActor
struct EmptyStateViewSnapshotTests {
    @Test func withCTA() {
        let view = snapshotHost {
            EmptyStateView(
                systemImage: "person.2.slash",
                title: "No connections yet",
                message: "Once someone vouches for you, they'll show up here.",
                actionTitle: "Invite a friend"
            ) {}
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }

    @Test func withoutCTA() {
        let view = snapshotHost {
            EmptyStateView(
                systemImage: "clock",
                title: "Nothing pending",
                message: "Requests you send will appear here until they're accepted."
            )
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }
}
