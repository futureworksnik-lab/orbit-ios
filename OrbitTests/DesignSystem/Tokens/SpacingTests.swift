//
//  SpacingTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//

import CoreGraphics
import Testing
@testable import Orbit

struct SpacingTests {
    @Test func gridValues() {
        #expect(Spacing.s4 == 4)
        #expect(Spacing.s8 == 8)
        #expect(Spacing.s12 == 12)
        #expect(Spacing.s16 == 16)
        #expect(Spacing.s24 == 24)
        #expect(Spacing.s32 == 32)
        #expect(Spacing.s48 == 48)
        #expect(Spacing.s64 == 64)
    }

    @Test func semanticAliases() {
        #expect(Spacing.screenPadding == Spacing.s16)
        #expect(Spacing.cardInset == Spacing.s16)
        #expect(Spacing.sectionGap == Spacing.s24)
    }
}
