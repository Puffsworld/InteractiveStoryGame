//
//  GamePlayView.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/22/25.
//

import SwiftUI

struct GamePlayView: View {
    @StateObject private var viewModel: GamePlayViewModel
    
    // New initializer for direct injection
    init(viewModel: GamePlayViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // Existing initializer for production use
    init(fileName: String, initialStoryID: String) {
        let vm = GamePlayViewModel(initialStoryID: initialStoryID, fileName: fileName)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading{
                ProgressView("Loading story...")
            } else{
                if let node = viewModel.currentStoryModel {
                    VStack(spacing: 20) {
                        if let imageName = node.imageName, !imageName.isEmpty {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding()
                        } // #Image
                            
                        Text(node.storyText)
                            .padding()
                        
                        ForEach(node.choices) { choice in
                            StoryChoiceButton(
                                model: StoryChoiceButtonModel(
                                    text: choice.text,
                                    hint: choice.hint,
                                    action: {
                                        viewModel.makeChoice(choice)
                                    }
                                )
                            )
                        } // #Choice Buttons
                    }
                }
            }
        }
//        .onAppear {
////            TODO: solve the issue of first time started called reset game.
//            viewModel.resetGame()
//        }
    }
}

#Preview {
    let mockNode = StoryNodeModel(
        id: "start",
        loggingID: "mock_start",
        storyText: "You stand at the entrance of the jungle, map in hand. The lost treasure awaits. What will you do?",
        imageName: "jungle_entrance",
        choices: [
            ChoiceModel(text: "Enter the jungle", hint: "Brave the unknown", destinationID: "jungle_path"),
            ChoiceModel(text: "Return home", hint: "Give up the quest", destinationID: "ending_giveup")
        ],
        
    )
    let mockNode2 = StoryNodeModel(
        id: "jungle_path",
        loggingID: "mock_jungle_path",
        storyText: "You venture into the jungle, the sounds of wildlife all around you. Suddenly, you hear a rustling in the bushes.",
        imageName: "jungle_path",
        choices: [
            ChoiceModel(text: "Investigate the sound", hint: "Could be an animal", destinationID: "animal_encounter"),
            ChoiceModel(text: "Give up", hint: "Stay focused on the goal", destinationID: "start")
        ],
    )
    let mockViewModel =  GamePlayViewModel(initalStoryID: "start", stories: ["start": mockNode, "jungle_path": mockNode2])
    GamePlayView(viewModel: mockViewModel)
}

// Helper wrapper to inject the mock view model
struct GamePlayView_PreviewWrapper: View {
    @StateObject var viewModel: GamePlayViewModel
    var body: some View {
        GamePlayView(viewModel: viewModel)
    }
}
