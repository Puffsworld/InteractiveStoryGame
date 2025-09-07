//
//  ChoiceView.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 9/6/25.
//

import SwiftUI

struct ChoiceView: View {
    let choices: [ChoiceModel]
    let onChoiceSelected: (ChoiceModel) -> Void
    let type: StoryNodeType

    init(
        choices: [ChoiceModel],
        onChoiceSelected: @escaping (ChoiceModel) -> Void,
        type:StoryNodeType = .standard
    ) {
        self.choices = choices
        self.onChoiceSelected = onChoiceSelected
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
            // TODO: update the ending view to have a return to home button and
            // a restart button that reset the game.
            EmptyView() // Placeholder for ending case
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
        onChoiceSelected: { _ in },
        type: .ending
    )
}
