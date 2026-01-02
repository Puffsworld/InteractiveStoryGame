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
    // Use the bundle where the test class is located to find the test manifest
    viewModel = HomeViewModel(
      storyManifestFileName: "StoriesManifestTest",
      bundle: Bundle(for: HomeViewModelTests.self)
    )
  }

  override func tearDownWithError() throws {
    viewModel = nil
  }

  func testLoadStories() throws {
    // Since loadStories is called in init, we check the results immediately

    // Check Featured Story: "The Lost Treasure" (Featured)
    XCTAssertNotNil(viewModel.featuredStory)
    XCTAssertEqual(viewModel.featuredStory?.title, "The Lost Treasure")
    XCTAssertEqual(viewModel.featuredStory?.category, .featured)

    // Check Top Picks: "Space Rescue" (Top Pick)
    // Note: "Journey to the Underworld" is Fantasy and currently not included in topPicks logic (TopPick or SciFi)
    XCTAssertFalse(viewModel.topPicks.isEmpty)
    XCTAssertEqual(
      viewModel.topPicks.count, 1,
      "Expected 1 Top Pick (Space Rescue), found \(viewModel.topPicks.count)")
    XCTAssertEqual(viewModel.topPicks.first?.title, "Space Rescue")
    XCTAssertEqual(viewModel.topPicks.first?.category, .topPick)

    // Check Quick Reads: "Mystery at the Manor" (Quick Read)
    XCTAssertFalse(viewModel.quickReads.isEmpty)
    XCTAssertEqual(
      viewModel.quickReads.count, 1,
      "Expected 1 Quick Read (Mystery at the Manor), found \(viewModel.quickReads.count)")
    XCTAssertEqual(viewModel.quickReads.first?.title, "Mystery at the Manor")
    XCTAssertEqual(viewModel.quickReads.first?.category, .quickRead)
  }

  func testLoadStoriesFailure() {
    // Test with a non-existent file
    viewModel = HomeViewModel(storyManifestFileName: "NonExistentFile")
    XCTAssertNil(viewModel.featuredStory)
    XCTAssertTrue(viewModel.topPicks.isEmpty)
    XCTAssertTrue(viewModel.quickReads.isEmpty)
  }
}
