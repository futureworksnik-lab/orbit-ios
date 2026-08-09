//
//  EmptyStateView.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — generic empty-state placeholder, built on design tokens (CP-3). Icon point size
//  has no dedicated spacing/radius/typography token in §4.3/§4.2 — reusing `TypeSpec.h1.size`
//  (34pt) rather than introducing a new bare numeric literal; flagged as a token-layer gap in the
//  WIP-4.C report, not silently dropped in.
//

import SwiftUI

/// Icon + title + message, with an optional CTA. When both `actionTitle` and `action` are
/// non-nil the CTA renders as a plain `OrbitButton` — its tap haptic (`Haptics.selectTap()`) is
/// inherited for free, nothing new to wire here.
struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: systemImage)
                .font(.system(size: TypeSpec.h1.size))
                .foregroundStyle(Color.textTertiary)

            Text(title)
                .font(.orbitH3)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.top, Spacing.s16)

            Text(message)
                .font(.orbitBody)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.top, Spacing.s16)

            if let actionTitle, let action {
                OrbitButton(title: actionTitle, kind: .primary, action: action)
                    .padding(.top, Spacing.s24)
            }
        }
        .padding(Spacing.s16)
    }
}

#Preview {
    HStack(spacing: Spacing.s24) {
        EmptyStateView(
            systemImage: "person.2.slash",
            title: "No connections yet",
            message: "Once someone vouches for you, they'll show up here.",
            actionTitle: "Invite a friend"
        ) {}
        EmptyStateView(
            systemImage: "clock",
            title: "Nothing pending",
            message: "Requests you send will appear here until they're accepted."
        )
    }
    .padding(Spacing.s16)
    .background(Color.bgSpace)
}
