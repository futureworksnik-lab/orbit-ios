//
//  TokenPreview.swift
//  Orbit
//
//  Created by Nikhil Gour on 08/09/26.
//
//  Swatch sheet for eyeballing the design-system tokens defined under DesignSystem/Tokens/.
//  Not a shipped screen — a development aid per TRD_D1_Foundation.md CP-3 step 4.
//

import SwiftUI

struct TokenPreviewView: View {
    @State private var isButtonPressed = false

    private let colorTokens: [(name: String, color: Color)] = [
        ("bgSpace", .bgSpace),
        ("surface1", .surface1),
        ("surface2", .surface2),
        ("borderHairline", .borderHairline),
        ("indigoPrimary", .indigoPrimary),
        ("indigoPressed", .indigoPressed),
        ("indigoSoft", .indigoSoft),
        ("indigoGlow", .indigoGlow),
        ("textPrimary", .textPrimary),
        ("textSecondary", .textSecondary),
        ("textTertiary", .textTertiary),
        ("successMint", .successMint),
        ("errorRed", .errorRed),
        ("warningAmber", .warningAmber),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.sectionGap) {
                colorSection
                typographySection
                layoutSection
                motionSection
            }
            .padding(Spacing.screenPadding)
        }
        .background(Color.bgSpace)
    }

    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colors").orbitLabelStyle().foregroundStyle(Color.textSecondary)
            ForEach(colorTokens, id: \.name) { token in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(token.color)
                        .frame(width: 48, height: 32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.borderHairline, lineWidth: 1)
                        )
                    Text("\(token.name)  \(hexString(for: token.color))")
                        .font(.orbitFootnote)
                        .foregroundStyle(Color.textPrimary)
                }
            }
        }
    }

    private var typographySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Typography").orbitLabelStyle().foregroundStyle(Color.textSecondary)
            Text("H1 — orbitH1").font(.orbitH1).foregroundStyle(Color.textPrimary)
            Text("H2 — orbitH2").font(.orbitH2).foregroundStyle(Color.textPrimary)
            Text("H3 — orbitH3").font(.orbitH3).foregroundStyle(Color.textPrimary)
            Text("Title — orbitTitle").font(.orbitTitle).foregroundStyle(Color.textPrimary)
            Text("Body — orbitBody").font(.orbitBody).foregroundStyle(Color.textPrimary)
            Text("Callout — orbitCallout").font(.orbitCallout).foregroundStyle(Color.textPrimary)
            Text("Subhead — orbitSubhead").font(.orbitSubhead).foregroundStyle(Color.textPrimary)
            Text("Footnote — orbitFootnote").font(.orbitFootnote).foregroundStyle(Color.textPrimary)
            Text("Caption — orbitCaption").font(.orbitCaption).foregroundStyle(Color.textPrimary)
            Text("Button — orbitButton").font(.orbitButton).foregroundStyle(Color.textPrimary)
            Text("Label — orbitLabelStyle").orbitLabelStyle().foregroundStyle(Color.textPrimary)
        }
    }

    private var layoutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Layout").orbitLabelStyle().foregroundStyle(Color.textSecondary)
            VStack(alignment: .leading, spacing: Spacing.s8) {
                Text("Card — Radius.card + e2 shadow")
                    .font(.orbitSubhead)
                    .foregroundStyle(Color.textPrimary)
                Text("Spacing.cardInset padding")
                    .font(.orbitFootnote)
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(Spacing.cardInset)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Radius.card)
                    .fill(Color.surface1)
            )
            .orbitShadow(.e2)
        }
    }

    private var motionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Motion + Haptics").orbitLabelStyle().foregroundStyle(Color.textSecondary)
            Text("Tap — orbitInteractive spring + .impact(.light)")
                .font(.orbitFootnote)
                .foregroundStyle(Color.textSecondary)
            Text("Tap me")
                .font(.orbitButton)
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, Spacing.s24)
                .padding(.vertical, Spacing.s12)
                .background(
                    RoundedRectangle(cornerRadius: Radius.button)
                        .fill(Color.indigoPrimary)
                )
                .scaleEffect(isButtonPressed ? 0.92 : 1)
                .animation(.orbitInteractive, value: isButtonPressed)
                .onTapGesture {
                    Haptics.selectTap()
                    isButtonPressed.toggle()
                }
        }
    }

    /// Derives the swatch label's hex string from the actual rendered color, so it can never
    /// hand-transcribe (and drift from) the token's real value.
    private func hexString(for color: Color) -> String {
        let rgba = color.rgba255()
        return String(format: "#%02X%02X%02X", rgba.r, rgba.g, rgba.b)
    }
}

#Preview {
    TokenPreviewView()
}
