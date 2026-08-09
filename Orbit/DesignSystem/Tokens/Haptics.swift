//
//  Haptics.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  TRD_PARENT.md §4.3 haptic map — law, D3 must match exactly.
//

import UIKit

enum Haptics {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    /// §4.3 haptic map, purpose-named to match verbatim.
    static func selectTap() {
        impact(.light)
    }

    static func sendIntro() {
        impact(.medium)
    }

    /// The payoff — accept/reveal is the emotional peak of the flow.
    static func acceptReveal() {
        notification(.success)
    }

    static func error() {
        notification(.error)
    }

    static func rateLimitHit() {
        notification(.warning)
    }

    static func chipToggle() {
        selection()
    }
}
