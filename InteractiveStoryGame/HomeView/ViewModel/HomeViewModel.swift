//
//  HomeViewModel.swift
//  InteractiveStoryGame
//
//  Created for Homepage Modernization
//

import Foundation

class HomeViewModel: ObservableObject {
  /// The main story highlighted at the top of the home screen.
  @Published var featuredStory: GalleryCellViewModel?
  /// A collection of recommended stories based on popularity or user preference.
  @Published var topPicks: [GalleryCellViewModel] = []
  /// A collection of short stories designed for quick consumption.
  @Published var quickReads: [GalleryCellViewModel] = []

  init(storyManifestFileName: String = "StoryManifestExample", bundle: Bundle = .main) {
    self.loadStories(from: storyManifestFileName, bundle: bundle)
  }

  func loadStories(from fileName: String, bundle: Bundle) {
    guard let url = bundle.url(forResource: fileName, withExtension: "json"),
      let data = try? Data(contentsOf: url),
      let stories = try? JSONDecoder().decode([StoryModel].self, from: data)
    else {
      print("Error: Failed to load or decode \(fileName).json from bundle.")
      return
    }

    self.featuredStory = stories.first(where: { $0.category == .featured }).map {
      GalleryCellViewModel(storyModel: $0)
    }

    self.topPicks =
      stories
      .filter { $0.category == .topPick || $0.category == .scifi }
      .map { GalleryCellViewModel(storyModel: $0) }

    self.quickReads =
      stories
      .filter { $0.category == .quickRead || $0.category == .mystery }
      .map { GalleryCellViewModel(storyModel: $0) }
  }
}
