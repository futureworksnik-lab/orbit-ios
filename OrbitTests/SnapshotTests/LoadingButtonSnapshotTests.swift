//
//  LoadingButtonSnapshotTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — snapshot coverage for LoadingButton (WIP-4.A). Only rest state per kind is
//  covered here: the loading state is transient/async and already covered via
//  `OrbitButton(isLoading: true)`'s own snapshot in OrbitButtonSnapshotTests — duplicating it
//  through LoadingButton's own `@State` would test the same rendered output twice.
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Orbit

@MainActor
struct LoadingButtonSnapshotTests {
    @Test func primaryRest() {
        let view = snapshotHost { LoadingButton(title: "Continue", kind: .primary) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }

    @Test func secondaryRest() {
        let view = snapshotHost { LoadingButton(title: "Continue", kind: .secondary) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }

    @Test func destructiveRest() {
        let view = snapshotHost { LoadingButton(title: "Continue", kind: .destructive) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }
}
