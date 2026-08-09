//
//  ColorTokensTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//

import SwiftUI
import Testing
@testable import Orbit

struct ColorTokensTests {
    private struct ColorCase {
        let name: String
        let color: Color
        let r: Int
        let g: Int
        let b: Int
    }

    private static let cases: [ColorCase] = [
        ColorCase(name: "bgSpace", color: .bgSpace, r: 0x0A, g: 0x0A, b: 0x0F),
        ColorCase(name: "surface1", color: .surface1, r: 0x15, g: 0x15, b: 0x1F),
        ColorCase(name: "surface2", color: .surface2, r: 0x1E, g: 0x1E, b: 0x2A),
        ColorCase(name: "borderHairline", color: .borderHairline, r: 0x2A, g: 0x2A, b: 0x38),
        ColorCase(name: "indigoPrimary", color: .indigoPrimary, r: 0x5B, g: 0x5B, b: 0xF5),
        ColorCase(name: "indigoPressed", color: .indigoPressed, r: 0x4A, g: 0x4A, b: 0xE0),
        ColorCase(name: "indigoSoft", color: .indigoSoft, r: 0x8B, g: 0x8B, b: 0xFF),
        ColorCase(name: "indigoGlow", color: .indigoGlow, r: 0x5B, g: 0x5B, b: 0xF5),
        ColorCase(name: "textPrimary", color: .textPrimary, r: 0xF5, g: 0xF5, b: 0xFA),
        ColorCase(name: "textSecondary", color: .textSecondary, r: 0xA0, g: 0xA0, b: 0xB2),
        ColorCase(name: "textTertiary", color: .textTertiary, r: 0x6B, g: 0x6B, b: 0x7B),
        ColorCase(name: "successMint", color: .successMint, r: 0x34, g: 0xD3, b: 0x9A),
        ColorCase(name: "errorRed", color: .errorRed, r: 0xF2, g: 0x49, b: 0x5C),
        ColorCase(name: "warningAmber", color: .warningAmber, r: 0xF5, g: 0xA6, b: 0x23),
    ]

    @Test(arguments: cases)
    private func tokenMatchesHex(_ testCase: ColorCase) {
        let rgba = testCase.color.rgba255()
        #expect(rgba.r == testCase.r, "\(testCase.name) red channel")
        #expect(rgba.g == testCase.g, "\(testCase.name) green channel")
        #expect(rgba.b == testCase.b, "\(testCase.name) blue channel")
    }

    @Test func indigoGlowAlphaIs40Percent() {
        let rgba = Color.indigoGlow.rgba255()
        #expect(abs(rgba.a - 102) <= 1)
    }
}
