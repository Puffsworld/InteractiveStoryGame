//
//  StoryChoiceButton.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/17/25.
//

import SwiftUI

// MARK: - Button Style

// ButtonStyle is a SwiftUI protocol that lets you fully own how a Button looks.
// You implement a single method, makeBody(configuration:), which SwiftUI calls
// every time the button needs to be rendered.
//
// The configuration parameter gives you two things:
//   - configuration.label: the view the caller put inside Button
//   - configuration.isPressed: true while the user holds down
struct GamePlayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        // Runtime OS version check. This keeps one binary working on older
        // systems while still using Liquid Glass where it exists.
        if #available(iOS 26, *) {
            configuration.label
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .glassEffect(.regular.interactive())
                .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        } else {
            configuration.label
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(.white.opacity(0.3), lineWidth: 0.5)
                )
                .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}

// MARK: - Story Choice Button

struct StoryChoiceButton: View {
    let model: StoryChoiceButtonModel
    @State private var isHovering: Bool = false

    init(model: StoryChoiceButtonModel) {
        self.model = model
    }

    var body: some View {
        if #available(iOS 26, *) {
            GlassEffectContainer(spacing: 8) {
                buttonContent
            }
        } else {
            buttonContent
        }
    }

    @ViewBuilder
    private var buttonContent: some View {
        ZStack {
            Button(action: model.action) {
                Text(model.text)
            }
            .buttonStyle(GamePlayButtonStyle())
            .padding(.horizontal, 24)
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

// MARK: - Preview

#Preview {
    ZStack {
        LinearGradient(
            colors: [.purple, .indigo, .teal],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

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
}
