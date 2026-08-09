//
//  TypographyTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//

import SwiftUI
import Testing
@testable import Orbit

struct TypographyTests {
    @Test func h1() {
        #expect(TypeSpec.h1.size == 34)
        #expect(TypeSpec.h1.weight == .bold)
    }

    @Test func h2() {
        #expect(TypeSpec.h2.size == 28)
        #expect(TypeSpec.h2.weight == .bold)
    }

    @Test func h3() {
        #expect(TypeSpec.h3.size == 22)
        #expect(TypeSpec.h3.weight == .semibold)
    }

    @Test func title() {
        #expect(TypeSpec.title.size == 20)
        #expect(TypeSpec.title.weight == .semibold)
    }

    @Test func body() {
        #expect(TypeSpec.body.size == 17)
        #expect(TypeSpec.body.weight == .regular)
    }

    @Test func callout() {
        #expect(TypeSpec.callout.size == 16)
        #expect(TypeSpec.callout.weight == .medium)
    }

    @Test func subhead() {
        #expect(TypeSpec.subhead.size == 15)
        #expect(TypeSpec.subhead.weight == .medium)
    }

    @Test func footnote() {
        #expect(TypeSpec.footnote.size == 13)
        #expect(TypeSpec.footnote.weight == .regular)
    }

    @Test func caption() {
        #expect(TypeSpec.caption.size == 12)
        #expect(TypeSpec.caption.weight == .regular)
    }

    @Test func button() {
        #expect(TypeSpec.button.size == 17)
        #expect(TypeSpec.button.weight == .semibold)
    }

    @Test func label() {
        #expect(TypeSpec.label.size == 13)
        #expect(TypeSpec.label.weight == .medium)
    }

    @Test func labelTracking() {
        #expect(TypeSpec.labelTrackingPercent == 0.08)
    }
}
