//
//  RadiusTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//

import CoreGraphics
import Testing
@testable import Orbit

struct RadiusTests {
    @Test func numericValues() {
        #expect(Radius.card == 20)
        #expect(Radius.button == 14)
        #expect(Radius.chip == 12)
        #expect(Radius.input == 12)
        #expect(Radius.sheet == 28)
        #expect(Radius.thumbnail == 8)
    }

    @Test func avatarIsInfinity() {
        #expect(Radius.avatar == .infinity)
    }
}
