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
    // if the story is loading
    var isLoading: Bool = false

    public init(initialStoryID: String, fileName: String, bundle: Bundle = .main) {
        self.initialStoryID = initialStoryID
        loadStoryNodes(from: fileName, bundle: bundle)
        if self.stories != nil {
            self.currentStoryModel =
                stories[initialStoryID]
        }
    }
    
    public init(initalStoryID: String, stories: [String: StoryNodeModel]) {
        self.initialStoryID = initalStoryID
        self.stories = stories
        self.currentStoryModel =
            stories[initialStoryID]
    }

    // Optionally, keep loadStoryNodes for manual reloads
    private func loadStoryNodes(from fileName: String, bundle: Bundle) -> Void {
        self.isLoading = true
        guard
            let url = bundle.url(
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
            self.isLoading = false
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
        self.isLoading = false
    }
    
    public func makeChoice(_ choice: ChoiceModel) -> Void {
        guard let nextNode = stories[choice.destinationID] else {
            print("Destination node not found: \(choice.destinationID)")
            return
        }
        // Update the current story model to the next node
        self.currentStoryModel = nextNode
        // Log the choice made
        self.storyLog.append("Chose: \(choice.text)")
        // Update the current choices available
        self.currentChoice = nextNode.choices
        // Update the path history
        self.pathHistory.append(nextNode.id)
    }
    
    public func resetGame() -> Void {
        self.currentStoryModel = stories[initialStoryID]
        self.storyLog = []
        self.currentChoice = currentStoryModel.choices
        self.pathHistory = [initialStoryID]
    }
}
