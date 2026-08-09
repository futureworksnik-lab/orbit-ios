//
//  OTPBoxField.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  CP-4 WIP-4.A — one-time-passcode entry. One hidden `TextField` instance drives autofill
//  (`.textContentType(.oneTimeCode)`); `length` separate text fields would break autofill.
//

import SwiftUI

/// One-time-passcode box entry, built on design tokens (CP-3). One hidden `TextField` backs
/// `code` for iOS autofill; a `HStack` of boxes renders the visible digits on top.
struct OTPBoxField: View {
    @Binding var code: String
    var length: Int = 6
    var errorMessage: String?

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            ZStack {
                boxRow

                TextField("", text: $code)
                    .focused($isFocused)
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                    .opacity(0.001)
                    .onChange(of: code) { _, newValue in
                        let digitsOnly = newValue.filter(\.isNumber)
                        code = String(digitsOnly.prefix(length))
                    }
            }
            .onTapGesture {
                isFocused = true
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

    private var boxRow: some View {
        HStack(spacing: Spacing.s8) {
            ForEach(0 ..< length, id: \.self) { index in
                box(at: index)
            }
        }
    }

    private func box(at index: Int) -> some View {
        RoundedRectangle(cornerRadius: Radius.input)
            .fill(Color.surface2)
            .frame(width: Spacing.s48, height: Spacing.s48)
            .overlay {
                RoundedRectangle(cornerRadius: Radius.input)
                    .strokeBorder(borderColor(at: index), lineWidth: 1)
            }
            .overlay {
                Text(digit(at: index))
                    .font(.orbitH3)
                    .foregroundStyle(Color.textPrimary)
            }
    }

    private func digit(at index: Int) -> String {
        guard index < code.count else { return "" }
        let characters = Array(code)
        return String(characters[index])
    }

    private func borderColor(at index: Int) -> Color {
        if errorMessage != nil {
            return .errorRed
        }
        if isFocused, index == code.count {
            return .indigoPrimary
        }
        return .borderHairline
    }
}

#Preview {
    VStack(spacing: Spacing.s24) {
        OTPBoxField(code: .constant(""))
        OTPBoxField(code: .constant("12"))
        OTPBoxField(code: .constant("123456"))
        OTPBoxField(code: .constant("123456"), errorMessage: "Incorrect code")
    }
    .padding(Spacing.s16)
    .background(Color.bgSpace)
}
