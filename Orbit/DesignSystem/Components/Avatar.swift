//
//  Avatar.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.B — avatar with initials fallback and optional mutual-path glyph, built on design
//  tokens (CP-3). Display-only: no haptic, no network image loading (Kingfisher isn't wired as a
//  dependency yet — a later D3 checkpoint composes `Avatar(image:)` around whatever loader it adds).
//

import SwiftUI

/// Pure, testable sizing logic for the mutual-path glyph badge, kept separate from the `View` so
/// it can be exercised with Swift Testing without any SwiftUI rendering.
enum AvatarGlyphAppearance {
    /// Badge diameter scales proportionally with the avatar's own size — never an absolute pixel
    /// value independent of `avatarSize`.
    static func badgeDiameter(avatarSize: CGFloat) -> CGFloat {
        avatarSize / 3
    }
}

/// Circular avatar. Renders `image` clipped to a circle at `size` when provided; otherwise falls
/// back to centered initials over a `.surface2` circle. `showsMutualPathGlyph` overlays a small
/// badge at the bottom-trailing corner marking a one-hop/mutual connection.
struct Avatar: View {
    var image: Image?
    let initials: String
    let size: CGFloat
    var showsMutualPathGlyph: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarContent
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: Radius.avatar))

            if showsMutualPathGlyph {
                mutualPathGlyph
            }
        }
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let image {
            image
                .resizable()
                .scaledToFill()
        } else {
            RoundedRectangle(cornerRadius: Radius.avatar)
                .fill(Color.surface2)
                .overlay {
                    Text(initials)
                        .font(.orbitTitle)
                        .foregroundStyle(Color.textPrimary)
                }
        }
    }

    private var mutualPathGlyph: some View {
        let diameter = AvatarGlyphAppearance.badgeDiameter(avatarSize: size)

        return RoundedRectangle(cornerRadius: Radius.avatar)
            .fill(Color.indigoPrimary)
            .frame(width: diameter, height: diameter)
            .overlay {
                Image(systemName: "person.2.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(diameter * 0.2)
                    .foregroundStyle(Color.textPrimary)
            }
            .overlay {
                RoundedRectangle(cornerRadius: Radius.avatar)
                    .strokeBorder(Color.borderHairline, lineWidth: 1)
            }
    }
}

#Preview {
    VStack(spacing: Spacing.s24) {
        HStack(spacing: Spacing.s24) {
            Avatar(initials: "NG", size: 64)
            Avatar(initials: "NG", size: 64, showsMutualPathGlyph: true)
        }
        HStack(spacing: Spacing.s24) {
            Avatar(image: Image(systemName: "photo.fill"), initials: "NG", size: 64)
            Avatar(image: Image(systemName: "photo.fill"), initials: "NG", size: 64, showsMutualPathGlyph: true)
        }
    }
    .padding(Spacing.s16)
    .background(Color.bgSpace)
}
