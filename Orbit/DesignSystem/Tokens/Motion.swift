//
//  Motion.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  TRD_PARENT.md §4.3 motion defaults — law, D3 must match exactly. 60fps non-negotiable.
//

import SwiftUI

enum MotionSpec {
    static let standardDuration: Double = 0.28
    static let interactiveResponse: Double = 0.4
    static let interactiveDamping: Double = 0.8
    static let revealResponse: Double = 0.55
    static let revealDamping: Double = 0.7
    static let cardFlipDuration: Double = 0.6
}

extension Animation {
    static let orbitStandard = Animation.easeInOut(duration: MotionSpec.standardDuration)
    static let orbitInteractive = Animation.spring(
        response: MotionSpec.interactiveResponse,
        dampingFraction: MotionSpec.interactiveDamping
    )
    static let orbitReveal = Animation.spring(
        response: MotionSpec.revealResponse,
        dampingFraction: MotionSpec.revealDamping
    )
    static let orbitCardFlip = Animation.easeInOut(duration: MotionSpec.cardFlipDuration)
}
