//
//  ChipChrome.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.B — visual chrome shared by OpenerChip and VibeTag, so neither file duplicates the
//  same background/border/text logic. Implementation detail only: not a standalone component,
//  never used directly by a screen — screens use OpenerChip/VibeTag.
//

import SwiftUI

/// Pure, testable token-resolution logic for the shared chip appearance. Kept separate from any
/// `View` so it can be exercised with Swift Testing without SwiftUI rendering.
enum ChipChromeAppearance {
    static func resolve(isSelected: Bool) -> (background: Color, border: Color?, foreground: Color) {
        if isSelected {
            return (background: .indigoPrimary, border: nil, foreground: .textPrimary)
        }
        return (background: .surface2, border: .borderHairline, foreground: .textSecondary)
    }
}

/// Shared fill/border/padding/label rendering for a single chip. `OpenerChip` and `VibeTag` each
/// wrap this in whatever interaction wrapper (or lack of one) their own semantics require.
struct ChipChromeLabel: View {
    let text: String
    let isSelected: Bool

    var body: some View {
        let appearance = ChipChromeAppearance.resolve(isSelected: isSelected)

        Text(text)
            .orbitLabelStyle()
            .foregroundStyle(appearance.foreground)
            .padding(.horizontal, Spacing.s12)
            .padding(.vertical, Spacing.s8)
            .background(appearance.background)
            .clipShape(RoundedRectangle(cornerRadius: Radius.chip))
            .overlay {
                if let border = appearance.border {
                    RoundedRectangle(cornerRadius: Radius.chip)
                        .strokeBorder(border, lineWidth: 1)
                }
            }
    }
}
