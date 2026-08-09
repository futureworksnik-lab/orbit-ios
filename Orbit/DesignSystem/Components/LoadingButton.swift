//
//  LoadingButton.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.A — thin async wrapper around `OrbitButton`, not a separately-styled component.
//

import SwiftUI

/// Wraps an `async` action in `OrbitButton`'s loading state — sets `isLoading` before awaiting
/// the action and clears it after, guarding against a double-tap while already in flight.
struct LoadingButton: View {
    let title: String
    let kind: OrbitButtonKind
    let action: () async -> Void

    @State private var isLoading = false

    var body: some View {
        OrbitButton(title: title, kind: kind, isLoading: isLoading) {
            guard !isLoading else { return }
            Task {
                isLoading = true
                await action()
                isLoading = false
            }
        }
    }
}

#Preview {
    VStack(spacing: Spacing.s16) {
        ForEach(Array(OrbitButtonKind.allCases.enumerated()), id: \.offset) { _, kind in
            LoadingButton(title: "Continue", kind: kind) {
                try? await Task.sleep(for: .seconds(1.5))
            }
        }
    }
    .padding(Spacing.s16)
    .background(Color.bgSpace)
}
