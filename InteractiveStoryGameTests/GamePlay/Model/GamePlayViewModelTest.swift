//
//  GamePlayViewModelTest.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/9/25.
//
import XCTest

@testable import InteractiveStoryGame

class GamePlayViewModelTest: XCTestCase {
    let initialStoryID: String = "start"
    var viewModel: GamePlayViewModel!
    let testFileName = "storyTesting"
    let expectedNodeCount = 7
    let startNodeStoryText = "You stand at the entrance of the jungle, map in hand. The lost treasure awaits. What will you do?"
    let startNodeChoicesCount = 2

    override func setUp() {
        super.setUp()
        viewModel = GamePlayViewModel(
            initialStoryID: initialStoryID
        )
        // The test file name should not include the extension
        viewModel.loadStoryNodes(from: testFileName)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testLoadStoryNodes() {
        // Test that the stories dictionary is populated
        XCTAssertNotNil(viewModel.stories, "Stories should be loaded and not nil")
        XCTAssertEqual(viewModel.stories.count, expectedNodeCount, "There should be \(expectedNodeCount) story nodes loaded")

        // Test that the current story model is set correctly
        XCTAssertNotNil(viewModel.currentStoryModel, "Current story model should be initialized")
        XCTAssertEqual(viewModel.currentStoryModel.id, initialStoryID, "The initial story node should be 'start'")
        XCTAssertEqual(viewModel.currentStoryModel.storyText, startNodeStoryText)
        XCTAssertEqual(viewModel.currentStoryModel.choices.count, startNodeChoicesCount)
    }
}
