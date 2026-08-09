//
//  ShadowTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//

import CoreGraphics
import Testing
@testable import Orbit

struct ShadowTests {
    @Test func e0IsNone() {
        #expect(OrbitShadow.e0.radius == 0)
        #expect(OrbitShadow.e0.x == 0)
        #expect(OrbitShadow.e0.y == 0)
    }

    @Test func e1() {
        #expect(OrbitShadow.e1.radius == 8)
        #expect(OrbitShadow.e1.x == 0)
        #expect(OrbitShadow.e1.y == 2)
        let rgba = OrbitShadow.e1.color.rgba255()
        #expect(abs(rgba.a - 51) <= 1)
    }

    @Test func e2() {
        #expect(OrbitShadow.e2.radius == 16)
        #expect(OrbitShadow.e2.x == 0)
        #expect(OrbitShadow.e2.y == 6)
        let rgba = OrbitShadow.e2.color.rgba255()
        #expect(abs(rgba.a - 77) <= 1)
    }

    @Test func e3() {
        #expect(OrbitShadow.e3.radius == 32)
        #expect(OrbitShadow.e3.x == 0)
        #expect(OrbitShadow.e3.y == 12)
        let rgba = OrbitShadow.e3.color.rgba255()
        #expect(abs(rgba.a - 102) <= 1)
    }

    @Test func glow() {
        #expect(OrbitShadow.glow.radius == 24)
        #expect(OrbitShadow.glow.x == 0)
        #expect(OrbitShadow.glow.y == 0)
    }
}
