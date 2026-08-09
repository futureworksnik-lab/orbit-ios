//
//  OrbitTextFieldTests.swift
//  OrbitTests
//
//  Created by Nikhil Gour on 08/09/26.
//
//  TDD seed for OrbitTextField (CP-4 WIP-4.A) — pure border-color-resolution logic, tested
//  before the SwiftUI view that consumes it exists.
//

import SwiftUI
import Testing
@testable import Orbit

struct OrbitTextFieldTests {
    @Test func defaultNoErrorNotFocused() {
        let color = OrbitTextField.borderColor(errorMessage: nil, isFocused: false)
        #expect(color == Color.borderHairline)
    }

    @Test func focusedNoError() {
        let color = OrbitTextField.borderColor(errorMessage: nil, isFocused: true)
        #expect(color == Color.indigoPrimary)
    }

    @Test func errorNotFocused() {
        let color = OrbitTextField.borderColor(errorMessage: "Required", isFocused: false)
        #expect(color == Color.errorRed)
    }

    @Test func errorWinsOverFocused() {
        let color = OrbitTextField.borderColor(errorMessage: "Required", isFocused: true)
        #expect(color == Color.errorRed)
    }
}
