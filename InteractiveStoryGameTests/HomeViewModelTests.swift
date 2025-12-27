//
//  HomeViewModelTests.swift
//  InteractiveStoryGameTests
//
//  Created for Homepage Modernization
//

import XCTest

@testable import InteractiveStoryGame

class HomeViewModelTests: XCTestCase {

  var viewModel: HomeViewModel!

  override func setUpWithError() throws {
    viewModel = HomeViewModel()
  }

  override func tearDownWithError() throws {
    viewModel = nil
  }

  func testLoadStories() throws {
    // Since loadStories is called in init, we check the results immediately

    // Check Featured Story
    XCTAssertNotNil(viewModel.featuredStory)
    XCTAssertEqual(viewModel.featuredStory?.title, "Project Odyssey")
    XCTAssertEqual(viewModel.featuredStory?.category, InteractiveStoryGame.StoryCategory.featured)

    // Check Top Picks
    XCTAssertFalse(viewModel.topPicks.isEmpty)
    XCTAssertEqual(viewModel.topPicks.count, 3)
    XCTAssertEqual(viewModel.topPicks.first?.category, InteractiveStoryGame.StoryCategory.topPick)  // The first mocked one is .topPick

    // Check Quick Reads
    XCTAssertFalse(viewModel.quickReads.isEmpty)
    XCTAssertEqual(viewModel.quickReads.count, 3)
    XCTAssertEqual(
      viewModel.quickReads.first?.category, InteractiveStoryGame.StoryCategory.quickRead)  // The first mocked one is .quickRead
  }
}
