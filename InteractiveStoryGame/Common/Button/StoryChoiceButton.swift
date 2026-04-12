//
//  StoryChoiceButton.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/17/25.
//

import SwiftUI

// MARK: - Button Style

// ButtonStyle is a SwiftUI protocol that lets you fully own how a Button looks.
// You implement a single method — makeBody(configuration:) — which SwiftUI calls
// every time the button needs to be rendered.
//
// The `configuration` parameter gives you two things:
//   • configuration.label  → the view the caller put inside Button { … }
//   • configuration.isPressed → a Bool that is true while the user holds down
struct GamePlayButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            // maxWidth: .infinity stretches the label to fill the button's
            // available width so the pill goes edge-to-edge in its parent.
            .frame(maxWidth: .infinity)
            .frame(height: 56)

            // ── Liquid Glass effect ───────────────────────────────────────
            // .glassEffect() is the iOS 26+ API that replaces the old
            // .background(.ultraThinMaterial) + .clipShape(Capsule()) combo.
            //
            // Full signature:
            //   glassEffect(_ effect: Glass = .regular, in shape: some Shape = Capsule())
            //
            // Calling it with no arguments gives us the defaults:
            //   effect → Glass.regular   standard Liquid Glass material
            //   shape  → Capsule()       the pill shape you already had
            //
            // What Liquid Glass actually does (vs ultraThinMaterial):
            //   • Blurs content behind the view — same blur, but GPU-composited
            //   • Reflects surrounding colours & light dynamically
            //   • Can react to touch/pointer in real time (see .interactive() below)
            //
            // Chaining .interactive() onto Glass.regular opts this view into the
            // same fluid press reaction you see on built-in system buttons —
            // the glass "squishes" and brightens under a finger or pointer.
            .glassEffect(.regular.interactive())
            // ─────────────────────────────────────────────────────────────

            // An extra scale-down on press gives tactile feedback on top of
            // the built-in interactive() response. 0.96 = shrinks to 96 % size.
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            // easeOut means the animation starts fast and slows at the end,
            // so the button "snaps" back naturally when the finger lifts.
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
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
        // GlassEffectContainer is Apple's recommended wrapper whenever you
        // render multiple glassEffect() views near each other (e.g. a list
        // of choice buttons stacked vertically).
        //
        // Two reasons to use it:
        //   1. Performance — it batches all glass rendering into a single
        //      GPU compositing pass instead of one pass per view.
        //   2. Morphing — when buttons animate in/out near each other, the
        //      glass outlines blend and morph together fluidly (like liquid).
        //
        // spacing: 8 controls the "merge distance". When two glass shapes
        // come within 8 pt of each other their outlines begin to fuse.
        // Increase the value to make them merge sooner, decrease it to keep
        // them visually separate until they actually touch.
        //
        // Note: if you have a parent view that renders ALL choice buttons
        // together (e.g. a VStack of StoryChoiceButtons), it is even better
        // to move the GlassEffectContainer up to that level so all buttons
        // share one container. For now it lives here for self-containment.
        GlassEffectContainer(spacing: 8) {
            ZStack {
                Button(action: model.action) {
                    Text(model.text)
                }
                .buttonStyle(GamePlayButtonStyle())
                .padding(.horizontal, 24)
                .onHover { hovering in
                    isHovering = hovering
                }

                // Tooltip shown on hover (macOS / iPadOS pointer). Unchanged.
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
}

// MARK: - Preview

// ⚠️ Important: Liquid Glass is a blur effect — it needs real visual content
// BEHIND the button to look like glass. Over a plain white/grey canvas the
// blur has nothing to work with and the effect is nearly invisible.
//
// The gradient below simulates the kind of rich game-scene background your
// buttons will actually sit on, so the preview matches the real experience.
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
