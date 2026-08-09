//
//  ChipChromeAppearanceTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.B — pure token-resolution logic shared by OpenerChip and VibeTag.
//

import SwiftUI
import Testing
@testable import Orbit

struct ChipChromeAppearanceTests {
    @Test func unselected() {
        let result = ChipChromeAppearance.resolve(isSelected: false)
        #expect(result.background == Color.surface2)
        #expect(result.border == Color.borderHairline)
        #expect(result.foreground == Color.textSecondary)
    }

    @Test func selected() {
        let result = ChipChromeAppearance.resolve(isSelected: true)
        #expect(result.background == Color.indigoPrimary)
        #expect(result.border == nil)
        #expect(result.foreground == Color.textPrimary)
    }
}
