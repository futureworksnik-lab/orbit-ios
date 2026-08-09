//
//  OTPBoxFieldSnapshotTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — snapshot coverage for OTPBoxField (WIP-4.A). The focused-box highlight state is
//  intentionally NOT covered here: `@FocusState` needs a real first-responder chain that
//  off-screen snapshot rendering doesn't reliably provide. Documented manual-QA gap, mirroring
//  how CP-3 documented its Haptics-testing gap.
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Orbit

@MainActor
struct OTPBoxFieldSnapshotTests {
    @Test func empty() {
        let view = snapshotHost { OTPBoxField(code: .constant("")) }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }

    @Test func partial() {
        let view = snapshotHost { OTPBoxField(code: .constant("12")) }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }

    @Test func full() {
        let view = snapshotHost { OTPBoxField(code: .constant("123456")) }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }

    @Test func error() {
        let view = snapshotHost {
            OTPBoxField(code: .constant("123456"), errorMessage: "Incorrect code")
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98, traits: .init(displayScale: 3)))
    }
}
