//
//  OrbitTextFieldSnapshotTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — snapshot coverage for OrbitTextField (WIP-4.A). The focused-border state is
//  intentionally NOT covered here: `@FocusState` needs a real first-responder chain that
//  off-screen snapshot rendering doesn't reliably provide. Documented manual-QA gap, mirroring
//  how CP-3 documented its Haptics-testing gap.
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Orbit

@MainActor
struct OrbitTextFieldSnapshotTests {
    @Test func defaultEmpty() {
        let view = snapshotHost {
            OrbitTextField(placeholder: "Campus email", text: .constant(""))
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func filled() {
        let view = snapshotHost {
            OrbitTextField(placeholder: "Campus email", text: .constant("nik@school.edu"))
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func error() {
        let view = snapshotHost {
            OrbitTextField(
                placeholder: "Campus email",
                text: .constant("nik@school"),
                errorMessage: "Enter a valid .edu address"
            )
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }
}
