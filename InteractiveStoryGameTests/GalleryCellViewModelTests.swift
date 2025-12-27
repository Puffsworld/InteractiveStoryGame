//
//  GalleryCellViewModelTests.swift
//  InteractiveStoryGameTests
//
//  Created for Homepage Modernization
//

import XCTest

@testable import InteractiveStoryGame

class GalleryCellViewModelTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testInitialization() throws {
    let storyModel = InteractiveStoryGame.StoryModel(
      id: "test_id",
      title: "Test Title",
      synopsis: "Test Synopsis",
      galleryImageName: "test_image",
      fileName: "test_file",
      initialStoryID: "start_node",
      category: InteractiveStoryGame.StoryCategory.featured,
      progress: 0.5
    )

    let viewModel = GalleryCellViewModel(storyModel: storyModel)

    XCTAssertEqual(viewModel.id, "test_id")
    XCTAssertEqual(viewModel.title, "Test Title")
    XCTAssertEqual(viewModel.synopsis, "Test Synopsis")
    XCTAssertEqual(viewModel.imageName, "test_image")
    XCTAssertEqual(viewModel.category, InteractiveStoryGame.StoryCategory.featured)
    XCTAssertEqual(viewModel.progress, 0.5)
  }

  func testCreateGamePlayViewModel() throws {
    let storyModel = InteractiveStoryGame.StoryModel(
      id: "test_id_2",
      title: "Game Title",
      synopsis: "Game Synopsis",
      galleryImageName: "game_image",
      fileName: "storyExample",
      initialStoryID: "custom_start",
      category: InteractiveStoryGame.StoryCategory.topPick,
      progress: 0.0
    )

    let viewModel = GalleryCellViewModel(storyModel: storyModel)
    let gameVM = viewModel.createGamePlayViewModel()

    XCTAssertNotNil(gameVM)
    // Verify it uses the initialStoryID from the model
    XCTAssertEqual(gameVM.initialStoryID, "custom_start")
  }
}
