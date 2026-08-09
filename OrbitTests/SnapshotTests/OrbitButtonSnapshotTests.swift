//
//  OrbitButtonSnapshotTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — snapshot coverage for OrbitButton (WIP-4.A). `ButtonStyleConfiguration` has no
//  public initializer, so a pressed state can't be driven through `makeBody(configuration:)` in a
//  test; pressed snapshots instead render a small static view built from
//  `OrbitButtonAppearance.resolve(isPressed: true, ...)`'s own output, mirroring
//  `OrbitButtonStyle`'s private layout exactly. No test-only parameter was added to `OrbitButton`'s
//  own public API to fake this.
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Orbit

@MainActor
struct OrbitButtonSnapshotTests {
    @Test func primaryRest() {
        let view = snapshotHost { OrbitButton(title: "Continue", kind: .primary) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func primaryDisabled() {
        let view = snapshotHost {
            OrbitButton(title: "Continue", kind: .primary) {}
                .disabled(true)
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func primaryLoading() {
        let view = snapshotHost { OrbitButton(title: "Continue", kind: .primary, isLoading: true) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func secondaryRest() {
        let view = snapshotHost { OrbitButton(title: "Continue", kind: .secondary) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func secondaryDisabled() {
        let view = snapshotHost {
            OrbitButton(title: "Continue", kind: .secondary) {}
                .disabled(true)
        }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func destructiveRest() {
        let view = snapshotHost { OrbitButton(title: "Continue", kind: .destructive) {} }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func primaryPressed() {
        let view = snapshotHost { PressedButtonSnapshot(kind: .primary) }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func secondaryPressed() {
        let view = snapshotHost { PressedButtonSnapshot(kind: .secondary) }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }

    @Test func destructivePressed() {
        let view = snapshotHost { PressedButtonSnapshot(kind: .destructive) }
        assertSnapshot(of: view, as: .image(perceptualPrecision: 0.98))
    }
}

/// Renders `OrbitButtonAppearance.resolve(isPressed: true, ...)`'s output as a static view,
/// mirroring `OrbitButtonStyle`'s private `makeBody(configuration:)` layout — that type can't be
/// constructed directly in a test since `ButtonStyleConfiguration` has no public initializer.
private struct PressedButtonSnapshot: View {
    let kind: OrbitButtonKind

    var body: some View {
        let appearance = OrbitButtonAppearance.resolve(kind: kind, isPressed: true, isEnabled: true)

        return Text("Continue")
            .font(.orbitButton)
            .foregroundStyle(appearance.foreground)
            .padding(.horizontal, Spacing.s24)
            .padding(.vertical, Spacing.s12)
            .frame(maxWidth: .infinity)
            .background(appearance.background)
            .clipShape(RoundedRectangle(cornerRadius: Radius.button))
            .overlay {
                if case .secondary = kind {
                    RoundedRectangle(cornerRadius: Radius.button)
                        .strokeBorder(Color.borderHairline, lineWidth: 1)
                }
            }
            .orbitShadow(appearance.shadow)
    }
}
