//
//  SkeletonView.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.C — loading-state shimmer placeholder, built on design tokens (CP-3). §4.3 defines
//  no shimmer-specific duration token — reusing `MotionSpec.standardDuration * 4` (a named
//  constant, scaled, not a new bare literal) for a slow, deliberate sweep, deliberately slower
//  than the 0.28s used for snappy interactive transitions. Mirrors how CP-3 documented its
//  `Radius.avatar = .infinity` interpretation as a deliberate, named decision.
//

import SwiftUI

/// Display-only loading placeholder — a `.surface2` block with an animated diagonal shimmer
/// sweep. No haptic: this view is never tapped, only ever looked at while content loads.
struct SkeletonView: View {
    var cornerRadius: CGFloat = Radius.thumbnail
    let height: CGFloat

    @State private var isAnimating = false

    var body: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.surface2)
                .overlay {
                    LinearGradient(
                        colors: [.surface2, .surface1, .surface2],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: proxy.size.width)
                    .offset(x: isAnimating ? proxy.size.width : -proxy.size.width)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: MotionSpec.standardDuration * 4)
                            .repeatForever(autoreverses: true)
                    ) {
                        isAnimating = true
                    }
                }
        }
        .frame(height: height)
    }
}

#Preview {
    VStack(spacing: Spacing.s16) {
        SkeletonView(height: 96)
        SkeletonView(cornerRadius: Radius.card, height: 140)
        SkeletonView(cornerRadius: Radius.thumbnail, height: 48)
    }
    .padding(Spacing.s16)
    .background(Color.bgSpace)
}
