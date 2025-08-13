//
//  ChoiceModel.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 7/29/25.
//

import Foundation

// This model represent a choice in the Story Event/ Page.
public struct ChoiceModel: Identifiable, Decodable, Equatable {
    // Unique identifier for the choice
    public var id: UUID
    // Text displayed for the choice button
    public let text: String
    // Optional hint text that can provide additional context or information of the choice
    public let hint: String?
    // Destination StoryNode ID that indicates where this choice will lead to Next StoryNode
    public let destinationID: String

    public init(id: UUID = UUID(), text: String, hint: String? = nil, destinationID: String) {
        self.id = id
        self.text = text
        self.hint = hint
        self.destinationID = destinationID
    }
    
    // MARK: - Decodable
    
    enum CodingKeys: String, CodingKey {
        case text
        case hint
        case destinationID
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID() // Manually create a UUID since it's not in the JSON
        self.text = try container.decode(String.self, forKey: .text)
        self.hint = try container.decodeIfPresent(String.self, forKey: .hint)
        self.destinationID = try container.decode(String.self, forKey: .destinationID)
    }
}
