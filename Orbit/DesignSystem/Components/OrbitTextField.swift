//
//  OrbitTextField.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.A — core reusable one-line text field, built on design tokens (CP-3).
//

import SwiftUI

/// Core reusable text field with an optional inline error message. Border color precedence:
/// error wins over focused wins over the default hairline.
struct OrbitTextField: View {
    let placeholder: String
    @Binding var text: String
    var errorMessage: String?

    @FocusState private var isFocused: Bool

    /// Pure, testable border-color-resolution logic, kept separate from the `View` body so it
    /// can be exercised with Swift Testing without any SwiftUI rendering.
    static func borderColor(errorMessage: String?, isFocused: Bool) -> Color {
        if errorMessage != nil {
            return .errorRed
        }
        if isFocused {
            return .indigoPrimary
        }
        return .borderHairline
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.textTertiary))
                .focused($isFocused)
                .font(.orbitBody)
                .foregroundStyle(Color.textPrimary)
                .padding(Spacing.s12)
                .background(Color.surface2)
                .clipShape(RoundedRectangle(cornerRadius: Radius.input))
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.input)
                        .strokeBorder(
                            Self.borderColor(errorMessage: errorMessage, isFocused: isFocused),
                            lineWidth: 1
                        )
                }

            if let errorMessage {
                Text(errorMessage)
                    .font(.orbitCaption)
                    .foregroundStyle(Color.errorRed)
            }
        }
        .onChange(of: errorMessage) { oldValue, newValue in
            if oldValue == nil, newValue != nil {
                Haptics.error()
            }
        }
    }
}

#Preview {
    // Real focus can't be forced from a static preview — default and error states are shown
    // here; focused-border behavior is exercised live in the simulator.
    VStack(spacing: Spacing.s16) {
        OrbitTextField(placeholder: "Campus email", text: .constant(""))
        OrbitTextField(placeholder: "Campus email", text: .constant("nik@school.edu"))
        OrbitTextField(
            placeholder: "Campus email",
            text: .constant("nik@school"),
            errorMessage: "Enter a valid .edu address"
        )
    }
    .padding(Spacing.s16)
    .background(Color.bgSpace)
}
