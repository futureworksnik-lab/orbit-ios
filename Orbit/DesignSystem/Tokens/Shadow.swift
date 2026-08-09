//
//  Shadow.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  TRD_PARENT.md §4.3 — shadow/elevation, law, D3 must be exact.
//
//  Named `OrbitShadow`, not `ShadowStyle` — `SwiftUI.ShadowStyle` is a real public iOS-17 type
//  (used by `ShapeStyle.shadow(_:)`); reusing that name would cause an ambiguous-use collision.
//

import SwiftUI

struct OrbitShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    static let e0 = OrbitShadow(color: .clear, radius: 0, x: 0, y: 0)
    static let e1 = OrbitShadow(color: .black.opacity(0.20), radius: 8, x: 0, y: 2)
    static let e2 = OrbitShadow(color: .black.opacity(0.30), radius: 16, x: 0, y: 6)
    static let e3 = OrbitShadow(color: .black.opacity(0.40), radius: 32, x: 0, y: 12)
    /// Reveal only — `.indigoGlow` already bakes in 40% opacity, don't double-apply `.opacity()`.
    static let glow = OrbitShadow(color: .indigoGlow, radius: 24, x: 0, y: 0)
}

extension View {
    func orbitShadow(_ style: OrbitShadow) -> some View {
        shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}
