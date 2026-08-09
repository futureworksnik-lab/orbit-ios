//
//  MotionTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//

import Testing
@testable import Orbit

struct MotionTests {
    @Test func standardDuration() {
        #expect(MotionSpec.standardDuration == 0.28)
    }

    @Test func interactiveSpring() {
        #expect(MotionSpec.interactiveResponse == 0.4)
        #expect(MotionSpec.interactiveDamping == 0.8)
    }

    @Test func revealSpring() {
        #expect(MotionSpec.revealResponse == 0.55)
        #expect(MotionSpec.revealDamping == 0.7)
    }

    @Test func cardFlipDuration() {
        #expect(MotionSpec.cardFlipDuration == 0.6)
    }
}
