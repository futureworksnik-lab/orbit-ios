//
//  OrbitButtonAppearanceTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  TDD seed for OrbitButton (CP-4 WIP-4.A) — pure token-resolution logic, tested before the
//  SwiftUI view that consumes it exists.
//

import SwiftUI
import Testing
@testable import Orbit

struct OrbitButtonAppearanceTests {
    // MARK: - primary

    @Test func primaryRestEnabled() {
        let result = OrbitButtonAppearance.resolve(kind: .primary, isPressed: false, isEnabled: true)
        #expect(result.background == Color.indigoPrimary)
        #expect(result.foreground == Color.textPrimary)
        #expect(result.shadow.radius == OrbitShadow.e1.radius)
    }

    @Test func primaryPressedEnabled() {
        let result = OrbitButtonAppearance.resolve(kind: .primary, isPressed: true, isEnabled: true)
        #expect(result.background == Color.indigoPressed)
        #expect(result.foreground == Color.textPrimary)
        #expect(result.shadow.radius == OrbitShadow.e0.radius)
    }

    @Test func primaryDisabled() {
        let result = OrbitButtonAppearance.resolve(kind: .primary, isPressed: false, isEnabled: false)
        #expect(result.background == Color.surface2)
        #expect(result.foreground == Color.textTertiary)
        #expect(result.shadow.radius == OrbitShadow.e0.radius)
    }

    @Test func primaryDisabledIgnoresPressed() {
        // Disabled wins over pressed — a disabled button cannot register a press.
        let result = OrbitButtonAppearance.resolve(kind: .primary, isPressed: true, isEnabled: false)
        #expect(result.background == Color.surface2)
        #expect(result.foreground == Color.textTertiary)
        #expect(result.shadow.radius == OrbitShadow.e0.radius)
    }

    // MARK: - secondary

    @Test func secondaryRestEnabled() {
        let result = OrbitButtonAppearance.resolve(kind: .secondary, isPressed: false, isEnabled: true)
        #expect(result.background == Color.surface2)
        #expect(result.foreground == Color.textPrimary)
        #expect(result.shadow.radius == OrbitShadow.e0.radius)
    }

    @Test func secondaryPressedEnabled() {
        // No distinct pressed background token exists for secondary — pressed feedback comes
        // from elsewhere (shadow stays flat, same as rest).
        let result = OrbitButtonAppearance.resolve(kind: .secondary, isPressed: true, isEnabled: true)
        #expect(result.background == Color.surface2)
        #expect(result.foreground == Color.textPrimary)
        #expect(result.shadow.radius == OrbitShadow.e0.radius)
    }

    @Test func secondaryDisabled() {
        let result = OrbitButtonAppearance.resolve(kind: .secondary, isPressed: false, isEnabled: false)
        #expect(result.background == Color.surface2)
        #expect(result.foreground == Color.textTertiary)
        #expect(result.shadow.radius == OrbitShadow.e0.radius)
    }

    // MARK: - destructive

    @Test func destructiveRestEnabled() {
        let result = OrbitButtonAppearance.resolve(kind: .destructive, isPressed: false, isEnabled: true)
        #expect(result.background == Color.errorRed)
        #expect(result.foreground == Color.textPrimary)
        #expect(result.shadow.radius == OrbitShadow.e1.radius)
    }

    @Test func destructivePressedEnabled() {
        // No `errorPressed` token exists — pressed feedback carried via shadow only.
        let result = OrbitButtonAppearance.resolve(kind: .destructive, isPressed: true, isEnabled: true)
        #expect(result.background == Color.errorRed)
        #expect(result.foreground == Color.textPrimary)
        #expect(result.shadow.radius == OrbitShadow.e0.radius)
    }

    @Test func destructiveDisabled() {
        let result = OrbitButtonAppearance.resolve(kind: .destructive, isPressed: false, isEnabled: false)
        #expect(result.background == Color.surface2)
        #expect(result.foreground == Color.textTertiary)
        #expect(result.shadow.radius == OrbitShadow.e0.radius)
    }
}
