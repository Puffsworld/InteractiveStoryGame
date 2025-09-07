//
//  ChoiceView.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 9/6/25.
//

import SwiftUI

struct ChoiceView: View {
    let choices: [ChoiceModel]
    // Use when a choice is selected
    let onChoiceSelected: (ChoiceModel) -> Void
    let type: StoryNodeType
    // Use when the game needs to be reset, e.g., only at the end of the story
    let resetGame: () -> Void

    @Environment(\.dismiss) var dismiss

    init(
        choices: [ChoiceModel],
        onChoiceSelected: @escaping (ChoiceModel) -> Void,
        resetGame: @escaping () -> Void = {},
        type: StoryNodeType = .standard
    ) {
        self.choices = choices
        self.onChoiceSelected = onChoiceSelected
        self.resetGame = resetGame
        self.type = type
    }

    var body: some View {
        switch type {
        case .standard:
            VStack(spacing: 12) {
                ForEach(choices) { choice in
                    StoryChoiceButton(
                        model: StoryChoiceButtonModel(
                            text: choice.text,
                            hint: choice.hint,
                            action: { onChoiceSelected(choice) },
                            conerRadius: 10,
                            backgroundColor: .blue
                        )
                    )
                }
            }
        case .ending:
            VStack(spacing: 20) {

                StartPageButton(
                    model: StartPageButtonModel(
                        name: "Restart Game",
                        action: { resetGame() },
                        cornerRadius: 10
                    )
                )

                StartPageButton(
                    model: StartPageButtonModel(
                        name: "Return to Home",
                        action: { dismiss() },
                        cornerRadius: 10
                    )
                )
            }
            .padding()
        }
    }
}

#Preview {
    ChoiceView(
        choices: [
            ChoiceModel(
                text: "Enter the jungle",
                hint: "Brave the unknown",
                destinationID: "jungle_path"
            ),
            ChoiceModel(
                text: "Return home",
                hint: "Give up the quest",
                destinationID: "ending_giveup"
            ),
        ],
        onChoiceSelected: { choice in
            print("Choice selected: \(choice.text)")
        },
        resetGame:{ print("Game reset") },
        type: .standard
    )
}
