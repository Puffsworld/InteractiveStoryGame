//
//  GamePlayViewModel.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/1/25.
//

import Foundation

class GamePlayViewModel: ObservableObject {
    // dicotionary of story nodes, where the key is the story ID and the value is the StoryNodeModel
    @Published var stories: [String: StoryNodeModel]!
    // The story logging information, used to track the story progress and choices made
    @Published var storyLog: [String] = []
    // The current story ID that is being played
    @Published var currentChoice: [ChoiceModel] = []
    // The current story node model that is being played
    @Published var currentStoryModel: StoryNodeModel!
    // The current story ID that is being played
    @Published var pathHistory: [String] = []
    // The initial story ID to start the game
    let initialStoryID: String

    public init(initialStoryID: String) {
        self.initialStoryID = initialStoryID
    }

    public func loadStoryNodes(from fileName: String) -> Void
    {
        guard
            let url = Bundle.main.url(
                forResource: fileName,
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let nodes = try? JSONDecoder().decode(
                [StoryNodeModel].self,
                from: data
            )
        else {
            print("Failed to load or decode story nodes from \(fileName).json")
            // TODO: Handle error appropriately, maybe set a default story or show an error message
            return
        }
        self.stories = Dictionary(uniqueKeysWithValues: nodes.map { ($0.id, $0) })
        self.currentStoryModel =
            stories[initialStoryID]
            ?? StoryNodeModel(
                id: initialStoryID,
                storyText: "Story not found",
                choices: []
            )
    }
}
