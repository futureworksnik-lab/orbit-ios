//
//  AvatarSnapshotTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — snapshot coverage for Avatar (WIP-4.B).
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Orbit

@MainActor
struct AvatarSnapshotTests {
    @Test func initialsFallback() {
        let view = snapshotHost { Avatar(initials: "NG", size: 64) }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }

    @Test func initialsFallbackWithGlyph() {
        let view = snapshotHost { Avatar(initials: "NG", size: 64, showsMutualPathGlyph: true) }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }

    @Test func withImage() {
        let view = snapshotHost {
            Avatar(image: Image(systemName: "photo.fill"), initials: "NG", size: 64)
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }

    @Test func withImageAndGlyph() {
        let view = snapshotHost {
            Avatar(
                image: Image(systemName: "photo.fill"),
                initials: "NG",
                size: 64,
                showsMutualPathGlyph: true
            )
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }
}
