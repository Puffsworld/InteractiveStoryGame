//
//  StoryChoiceButton.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/17/25.
//

import SwiftUI

struct GamePlayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold)) // Bold text for better glass contrast
            .foregroundColor(.white)
            .frame(maxWidth: .infinity) // Make text fill width
            .frame(height: 56) // Exact height from your spec
            .background(.ultraThinMaterial) // The glass effect
            .clipShape(Capsule()) // The pill shape
            .overlay(
                // The "Glass Edge" that catches light
                Capsule()
                    .stroke(.white.opacity(0.15), lineWidth: 0.5)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0) // Scale the whole pill!
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}


struct StoryChoiceButton: View {
    let model: StoryChoiceButtonModel
    @State private var isHovering: Bool = false

    init(model: StoryChoiceButtonModel) {
        self.model = model
    }

    var body: some View {
        ZStack {
            Button(action: model.action) {
                Text(model.text)
            }
            .buttonStyle(GamePlayButtonStyle())
            .padding(.horizontal, 24) // Added padding from spec for full-bleed feel
            .onHover { hovering in
                isHovering = hovering
            }
            if isHovering, let hint = model.hint, !hint.isEmpty {
                VStack {
                    Text(hint)
                        .font(.caption)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(model.conerRadius ?? 8)
                        .shadow(radius: 4)
                    Spacer()
                }
                .frame(maxWidth: 200)
                .offset(y: -50)
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
}

#Preview {
    StoryChoiceButton(
        model: StoryChoiceButtonModel(
            text: "Choice 1",
            hint: "Risky",
            action: {
                print("Choice 1 selected")
            }
        )
    )
}
