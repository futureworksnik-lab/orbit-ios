//
//  Color+Tokens.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  TRD_PARENT.md §4.1 color palette — law, D3 must be exact.
//

import SwiftUI

extension Color {
    /// Builds a `Color` from a 24-bit packed hex value (e.g. `0x5B5BF5`) via bit-shift
    /// decomposition. Deliberately non-failable — a String-parsing `init?(hex:)` would need
    /// a force-unwrap at every call site, which trips the `force_unwrapping` SwiftLint rule.
    init(hex: UInt32, opacity: Double = 1) {
        let red = Double((hex & 0xFF0000) >> 16) / 255
        let green = Double((hex & 0x00FF00) >> 8) / 255
        let blue = Double(hex & 0x0000FF) / 255
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }

    static let bgSpace = Color(hex: 0x0A0A0F)
    static let surface1 = Color(hex: 0x15151F)
    static let surface2 = Color(hex: 0x1E1E2A)
    static let borderHairline = Color(hex: 0x2A2A38)
    static let indigoPrimary = Color(hex: 0x5B5BF5)
    static let indigoPressed = Color(hex: 0x4A4AE0)
    static let indigoSoft = Color(hex: 0x8B8BFF)
    /// Reveal glow / aha moment only — 40% opacity is baked in, do not re-apply `.opacity()`.
    static let indigoGlow = Color(hex: 0x5B5BF5, opacity: 0.4)
    static let textPrimary = Color(hex: 0xF5F5FA)
    static let textSecondary = Color(hex: 0xA0A0B2)
    static let textTertiary = Color(hex: 0x6B6B7B)
    static let successMint = Color(hex: 0x34D39A)
    static let errorRed = Color(hex: 0xF2495C)
    static let warningAmber = Color(hex: 0xF5A623)

    /// Reads back the exact rendered 0–255 RGBA channel values, so tests and previews never
    /// hand-transcribe a hex literal that could drift from the real rendered color.
    func rgba255() -> (r: Int, g: Int, b: Int, a: Int) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (
            r: Int((red * 255).rounded()),
            g: Int((green * 255).rounded()),
            b: Int((blue * 255).rounded()),
            a: Int((alpha * 255).rounded())
        )
    }
}
