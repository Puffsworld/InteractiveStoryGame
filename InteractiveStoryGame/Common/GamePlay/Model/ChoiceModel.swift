//
//  ChoiceModel.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 7/29/25.
//

import Foundation

// This model represent a choice in the Story Event/ Page.
public struct ChoiceModel: Identifiable {
    // Unique identifier for the choice
    public let id = UUID()
    // Text displayed for the choice button
    public let text: String
    // Optional hint text that can provide additional context or information of the choice
    public let hint: String?
    // Destination StoryNode ID that indicates where this choice will lead to Next StoryNode
    public let destinationID: String

    public init(text: String, hint: String? = nil, destinationID: String) {
        self.text = text
        self.hint = hint
        self.destinationID = destinationID
    }
}
