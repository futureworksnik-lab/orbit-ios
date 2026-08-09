//
//  VibeTag.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.B — vibe tag, built on design tokens (CP-3) and the shared ChipChromeLabel visual
//  helper (ChipChrome.swift). Doubles as a static read-only display badge (discovery cards) or a
//  picker item — the presence of `onTap` decides which, not a separate mode flag.
//

import SwiftUI

/// `onTap == nil` renders a static, non-interactive display badge — no `Button` wrapper, no
/// haptic. `onTap != nil` renders a picker item wrapped in `Button`, firing the same chip-toggle
/// haptic as `OpenerChip` on tap.
struct VibeTag: View {
    let text: String
    var isSelected: Bool = false
    var onTap: (() -> Void)?

    var body: some View {
        if let onTap {
            Button {
                Haptics.chipToggle()
                onTap()
            } label: {
                ChipChromeLabel(text: text, isSelected: isSelected)
            }
            .buttonStyle(.plain)
        } else {
            ChipChromeLabel(text: text, isSelected: isSelected)
        }
    }
}

#Preview {
    HStack(spacing: Spacing.s12) {
        VibeTag(text: "Night owl", isSelected: false) {}
        VibeTag(text: "Night owl", isSelected: true) {}
        VibeTag(text: "Night owl")
    }
    .padding(Spacing.s16)
    .background(Color.bgSpace)
}
