//
//  StoryModel.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 7/29/25.
//

import Foundation

public enum StoryCategory: String, Codable, CaseIterable {
  case featured = "Featured"
  case topPick = "Top Pick"
  case quickRead = "Quick Read"
  case scifi = "Sci-Fi"
  case fantasy = "Fantasy"
  case mystery = "Mystery"
  // Fallback for older models or undefined categories
  case uncategorized = "Uncategorized"
}

// This model represents the entire story in the Interactive Story Game.
// This is the top level model that contains all the story nodes and metadata.
public struct StoryModel: Identifiable, Codable {
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

  // NEW: Category for gallery organization
  public let category: StoryCategory

  // NEW: Initial Node ID to start the story
  public let initialStoryID: String

  // NEW: Progress tracking (Optional, 0.0 to 1.0)
  public var progress: Double?

  public init(
    id: String,
    title: String,
    synopsis: String,
    galleryImageName: String?,
    fileName: String,
    initialStoryID: String,
    category: StoryCategory = .uncategorized,
    progress: Double? = nil
  ) {
    self.id = id
    self.title = title
    self.synopsis = synopsis
    self.galleryImageName = galleryImageName
    self.fileName = fileName
    self.initialStoryID = initialStoryID
    self.category = category
    self.progress = progress
  }
}
