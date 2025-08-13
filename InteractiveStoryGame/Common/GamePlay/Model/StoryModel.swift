//
//  StoryModel.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 7/29/25.
//

import Foundation

// This model represents the entire story in the Interactive Story Game.
// This is the top level model that contains all the story nodes and metadata.
public struct StoryModel: Identifiable, Decodable {
    // Unique identifier for the story
    public let id: String
    // The title of the Story
    public let title: String
    // A brief synopsis or description of the story
    public let synopsis: String
    // Optional image name for the story, used in gallery or overview
    public let galleryImageName: String?
    // The file name where the story data is stored, typically in JSON format
    public let fileName: String
    
    public init(id: String, title: String, synopsis: String, galleryImageName: String?, fileName: String) {
        self.id = id
        self.title = title
        self.synopsis = synopsis
        self.galleryImageName = galleryImageName
        self.fileName = fileName
    }
}
