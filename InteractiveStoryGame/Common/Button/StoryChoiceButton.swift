//
//  StoryChoiceButton.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/17/25.
//

import SwiftUI

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
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                    .background(model.backgroundColor)
                    .cornerRadius(model.conerRadius ?? 8)
                    .hoverEffect(.lift)
            }
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
