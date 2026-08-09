//
//  AvatarGlyphAppearanceTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.B — pure mutual-path glyph badge sizing logic for Avatar.
//

import CoreGraphics
import Testing
@testable import Orbit

struct AvatarGlyphAppearanceTests {
    @Test func badgeScalesProportionallyWithAvatarSize() {
        #expect(AvatarGlyphAppearance.badgeDiameter(avatarSize: 60) == 20)
        #expect(AvatarGlyphAppearance.badgeDiameter(avatarSize: 30) == 10)
    }

    @Test func badgeIsNeverLargerThanAvatar() {
        let size: CGFloat = 48
        #expect(AvatarGlyphAppearance.badgeDiameter(avatarSize: size) < size)
    }
}
