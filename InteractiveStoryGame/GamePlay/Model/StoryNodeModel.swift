//
//  StoryNodeModel.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 7/29/25.
//

import Foundation

// Enum to specify the type of the story node
public enum StoryNodeType: String, Decodable {
    // Standard story node with choices leading to other nodes
    case standard
    // Ending story node that concludes the story
    case ending
}

// This model represents a StoryNode in the Interactive Story Game.
// It contains all the information present in a story node, including the text, choices, and metadata.
public struct StoryNodeModel: Identifiable, Decodable {
    // Unique identifier for the StoryNode
    public let id: String
    // Text content of the StoryNode
    public let storyText: String
    // Optional image name associated with the StoryNode (use SwiftUI Image or image name)
    public let imageName: String?
    // List of choices available in this StoryNode
    public let choices: [ChoiceModel]
    // Type of the story node (standard or ending)
    public let type: StoryNodeType
    // Human-readable identifier for logging purposes
    public let loggingID: String
    
    public init(id: String, loggingID: String, storyText: String, imageName: String? = nil, choices: [ChoiceModel] = [], type: StoryNodeType = .standard, ) {
        self.id = id
        self.loggingID = loggingID
        self.storyText = storyText
        self.imageName = imageName
        self.choices = choices
        self.type = type
    }
}
