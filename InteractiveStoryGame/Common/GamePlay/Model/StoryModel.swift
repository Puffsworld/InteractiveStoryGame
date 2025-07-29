//
//  StoryModel.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 7/29/25.
//

import Foundation

// This model represents the entire story in the Interactive Story Game.
// This is the top level model that contains all the story nodes and metadata.

public struct StoryModel: Identifiable {
    public let id: String
    public let title: String
    public let synopsis: String
    public let galleryImageName: String?
    public let fileName: String
    
    public init(id: String, title: String, synopsis: String, galleryImageName: String?, fileName: String) {
        self.id = id
        self.title = title
        self.synopsis = synopsis
        self.galleryImageName = galleryImageName
        self.fileName = fileName
    }
}
