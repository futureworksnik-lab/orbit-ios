//
//  Typography.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  TRD_PARENT.md §4.2 typography — law, D3 must be exact. Fixed px/weight pairs, not
//  Dynamic-Type-scaled: §4.2's table has no Dynamic Type mapping anywhere in the source doc.
//

import SwiftUI

/// The real source of truth for Orbit's type scale. `Font` is an opaque SwiftUI type with no
/// public size/weight accessor, so tests and the `Font` extension below both read from here.
enum TypeSpec {
    static let h1 = (size: CGFloat(34), weight: Font.Weight.bold)
    static let h2 = (size: CGFloat(28), weight: Font.Weight.bold)
    static let h3 = (size: CGFloat(22), weight: Font.Weight.semibold)
    static let title = (size: CGFloat(20), weight: Font.Weight.semibold)
    static let body = (size: CGFloat(17), weight: Font.Weight.regular)
    static let callout = (size: CGFloat(16), weight: Font.Weight.medium)
    static let subhead = (size: CGFloat(15), weight: Font.Weight.medium)
    static let footnote = (size: CGFloat(13), weight: Font.Weight.regular)
    static let caption = (size: CGFloat(12), weight: Font.Weight.regular)
    static let button = (size: CGFloat(17), weight: Font.Weight.semibold)
    static let label = (size: CGFloat(13), weight: Font.Weight.medium)

    /// Label/overline tracking, expressed as a percentage of the label's point size (§4.2: "+8% tracking").
    static let labelTrackingPercent: CGFloat = 0.08
}

extension Font {
    // `orbit`-prefixed, not bare `.h1`/`.title`/`.body`/`.callout`/`.footnote`/`.caption` —
    // SwiftUI already declares those names as Dynamic Type statics on `Font`, and a same-named
    // redeclaration causes ambiguous-use compile errors at call sites.
    static let orbitH1 = Font.system(size: TypeSpec.h1.size, weight: TypeSpec.h1.weight)
    static let orbitH2 = Font.system(size: TypeSpec.h2.size, weight: TypeSpec.h2.weight)
    static let orbitH3 = Font.system(size: TypeSpec.h3.size, weight: TypeSpec.h3.weight)
    static let orbitTitle = Font.system(size: TypeSpec.title.size, weight: TypeSpec.title.weight)
    static let orbitBody = Font.system(size: TypeSpec.body.size, weight: TypeSpec.body.weight)
    static let orbitCallout = Font.system(size: TypeSpec.callout.size, weight: TypeSpec.callout.weight)
    static let orbitSubhead = Font.system(size: TypeSpec.subhead.size, weight: TypeSpec.subhead.weight)
    static let orbitFootnote = Font.system(size: TypeSpec.footnote.size, weight: TypeSpec.footnote.weight)
    static let orbitCaption = Font.system(size: TypeSpec.caption.size, weight: TypeSpec.caption.weight)
    static let orbitButton = Font.system(size: TypeSpec.button.size, weight: TypeSpec.button.weight)
    static let orbitLabel = Font.system(size: TypeSpec.label.size, weight: TypeSpec.label.weight)
}

extension View {
    /// Label/overline row per §4.2: "13/Medium, +8% tracking, UPPERCASE".
    func orbitLabelStyle() -> some View {
        font(.orbitLabel)
            .tracking(TypeSpec.label.size * TypeSpec.labelTrackingPercent)
            .textCase(.uppercase)
    }
}
