//
//  OrbitButton.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.A — core reusable button, built entirely on top of design tokens (CP-3).
//

import SwiftUI

/// The three visual treatments a button can take. Named to align with TRD_D3's component
/// contract, not List A/B banned vocabulary.
enum OrbitButtonKind: CaseIterable {
    case primary
    case secondary
    case destructive
}

/// Pure, testable token-resolution logic for `OrbitButton`. Kept separate from the `View` so it
/// can be exercised with Swift Testing without spinning up any SwiftUI rendering.
enum OrbitButtonAppearance {
    static func resolve(
        kind: OrbitButtonKind,
        isPressed: Bool,
        isEnabled: Bool
    ) -> (background: Color, foreground: Color, shadow: OrbitShadow) {
        guard isEnabled else {
            return (background: .surface2, foreground: .textTertiary, shadow: .e0)
        }

        switch kind {
        case .primary:
            return (
                background: isPressed ? .indigoPressed : .indigoPrimary,
                foreground: .textPrimary,
                shadow: isPressed ? .e0 : .e1
            )

        case .secondary:
            // No distinct pressed background token — pressed feedback comes from the shadow
            // only, and secondary's shadow is flat at rest, so there is no visible shadow delta.
            return (background: .surface2, foreground: .textPrimary, shadow: .e0)

        case .destructive:
            // No `errorPressed` token exists in CP-3 — carry pressed feedback via shadow only,
            // same pattern as secondary.
            return (
                background: .errorRed,
                foreground: .textPrimary,
                shadow: isPressed ? .e0 : .e1
            )
        }
    }
}

/// Custom `ButtonStyle` so pressed state is read the idiomatic SwiftUI way
/// (`configuration.isPressed`) rather than via a manual gesture recognizer.
private struct OrbitButtonStyle: ButtonStyle {
    let kind: OrbitButtonKind
    let isLoading: Bool

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        let appearance = OrbitButtonAppearance.resolve(
            kind: kind,
            isPressed: configuration.isPressed,
            isEnabled: isEnabled
        )

        return configuration.label
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
            .allowsHitTesting(!isLoading)
    }
}

/// Core reusable button — primary/secondary/destructive treatments, loading and disabled
/// states, all resolved through design tokens. No literal color/font/spacing/radius/shadow
/// values anywhere in this type.
struct OrbitButton: View {
    let title: String
    let kind: OrbitButtonKind
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button {
            Haptics.selectTap()
            action()
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Text(title)
                }
            }
        }
        .buttonStyle(OrbitButtonStyle(kind: kind, isLoading: isLoading))
    }
}

#Preview {
    // Pressed state can't be triggered in a static preview — exercise it live in the simulator.
    VStack(spacing: Spacing.s16) {
        ForEach(Array(OrbitButtonKind.allCases.enumerated()), id: \.offset) { _, kind in
            OrbitButton(title: "Continue", kind: kind) {}
            OrbitButton(title: "Continue", kind: kind) {}
                .disabled(true)
            OrbitButton(title: "Continue", kind: kind, isLoading: true) {}
        }
    }
    .padding(Spacing.s16)
    .background(Color.bgSpace)
}
