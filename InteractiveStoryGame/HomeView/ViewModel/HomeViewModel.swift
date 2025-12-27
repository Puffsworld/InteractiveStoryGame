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

  init() {
    loadStories()
  }

  func loadStories() {
    // Mock Data for now

    // Note: initialStoryID is mocked as "start" for all, assuming standard JSON structure

    let featured = StoryModel(
      id: "featured_1",
      title: "Project Odyssey",
      synopsis: "A journey through the stars.",
      galleryImageName: "project_odyssey_cover",
      fileName: "storyExample",
      initialStoryID: "start",
      category: .featured,
      progress: 0.45
    )

    self.featuredStory = GalleryCellViewModel(storyModel: featured)

    self.topPicks = [
      StoryModel(
        id: "tp_1", title: "The Lost City", synopsis: "Uncover ancient secrets.",
        galleryImageName: "lost_city_cover", fileName: "storyExample", initialStoryID: "start",
        category: .topPick, progress: nil),
      StoryModel(
        id: "tp_2", title: "Cosmic Voyage", synopsis: "Explore the unknown.",
        galleryImageName: "cosmic_voyage_cover", fileName: "storyExample", initialStoryID: "start",
        category: .scifi, progress: nil),
      StoryModel(
        id: "tp_3", title: "The Silent Sea", synopsis: "Beneath the waves.",
        galleryImageName: "silent_sea_cover", fileName: "storyExample", initialStoryID: "start",
        category: .mystery, progress: nil),
    ].map { GalleryCellViewModel(storyModel: $0) }

    self.quickReads = [
      StoryModel(
        id: "qr_1", title: "A Whispered Secret", synopsis: "Short and suspenseful.",
        galleryImageName: "whispered_secret", fileName: "storyExample", initialStoryID: "start",
        category: .quickRead, progress: nil),
      StoryModel(
        id: "qr_2", title: "Five Minute Mystery", synopsis: "Solve it fast.",
        galleryImageName: "five_minute_mystery", fileName: "storyExample", initialStoryID: "start",
        category: .mystery, progress: nil),
      StoryModel(
        id: "qr_3", title: "The Encounter", synopsis: "A strange meeting.",
        galleryImageName: "the_encounter", fileName: "storyExample", initialStoryID: "start",
        category: .scifi, progress: nil),
    ].map { GalleryCellViewModel(storyModel: $0) }
  }
}
