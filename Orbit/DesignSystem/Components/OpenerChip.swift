//
//  OpenerChip.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.B — opener picker chip (pick one at a time), built on design tokens (CP-3) and the
//  shared ChipChromeLabel visual helper (ChipChrome.swift).
//

import SwiftUI

/// Always-interactive picker chip for a pick-one-at-a-time group. Tapping fires `onTap`
/// unconditionally — the caller's ViewModel owns what "selected" means within its pick-one group,
/// this view has no selection state of its own beyond the `isSelected` it's told to render.
struct OpenerChip: View {
    let text: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            Haptics.chipToggle()
            onTap()
        } label: {
            ChipChromeLabel(text: text, isSelected: isSelected)
        }
        .buttonStyle(.plain)
        // HIG 44×44pt touch-target floor: the visual chip is intentionally compact, so the hit
        // area is grown via an existing token (Spacing.s48) rather than shrinking the chip itself.
        .frame(minHeight: Spacing.s48)
    }
}

#Preview {
    HStack(spacing: Spacing.s12) {
        OpenerChip(text: "Coffee run?", isSelected: false) {}
        OpenerChip(text: "Coffee run?", isSelected: true) {}
    }
    .padding(Spacing.s16)
    .background(Color.bgSpace)
}
