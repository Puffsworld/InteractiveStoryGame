//
//  GalleryCellViewModel.swift
//  InteractiveStoryGame
//
//  Created for Homepage Modernization
//

import Foundation
import SwiftUI

class GalleryCellViewModel: Identifiable, ObservableObject {
  let storyModel: StoryModel

  var id: String { storyModel.id }
  var title: String { storyModel.title }
  var synopsis: String { storyModel.synopsis }
  // Safe unwrap or empty string if nil, depends on usage. View handles empty logic usually.
  var imageName: String { storyModel.galleryImageName ?? "" }
  var category: StoryCategory { storyModel.category }
  var progress: Double { storyModel.progress ?? 0.0 }

  init(storyModel: StoryModel) {
    self.storyModel = storyModel
  }

  func createGamePlayViewModel() -> GamePlayViewModel {
    // Initializes the GamePlayViewModel with the metadata info.
    // Uses the initialStoryID from the model.
    return GamePlayViewModel(
      initialStoryID: storyModel.initialStoryID,
      fileName: storyModel.fileName
    )
  }
}
