//
//  OrbitCard.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.B — generic reusable card container, built on design tokens (CP-3).
//

import SwiftUI

/// Pure layout container — background, corner radius, hairline border, and elevation shadow
/// resolved entirely through tokens. No baked-in tap gesture or interaction: a screen that wants
/// a tappable card wraps this in `Button` itself.
struct OrbitCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(Spacing.cardInset)
            .background(Color.surface1)
            .clipShape(RoundedRectangle(cornerRadius: Radius.card))
            .overlay {
                RoundedRectangle(cornerRadius: Radius.card)
                    .strokeBorder(Color.borderHairline, lineWidth: 1)
            }
            .orbitShadow(.e2)
    }
}

#Preview {
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
    .padding(Spacing.s16)
    .background(Color.bgSpace)
}
