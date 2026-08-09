//
//  Radius.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  TRD_PARENT.md §4.3 — corner radius, law, D3 must be exact.
//

import CoreGraphics

enum Radius {
    static let card: CGFloat = 20
    static let button: CGFloat = 14
    static let chip: CGFloat = 12
    static let input: CGFloat = 12
    static let sheet: CGFloat = 28
    static let thumbnail: CGFloat = 8
    /// §4.3 specifies "avatar circle" with no fixed pt value. `.infinity` is the correct SwiftUI
    /// idiom here — it clamps a `RoundedRectangle`/`.cornerRadius` to a true circle on any square frame.
    static let avatar: CGFloat = .infinity
}
