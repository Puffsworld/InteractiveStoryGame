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
            initialStoryID: initialStoryID,
            fileName: testFileName
        )
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testLoadStoryNodes() {
        // This test verifies that the GamePlayViewModel loads story nodes correctly from the JSON file.
        // It checks that the stories dictionary is populated, the correct number of nodes are loaded,
        // and the initial story node is set up with the expected text and choices.
        XCTAssertNotNil(viewModel.stories, "Stories should be loaded and not nil")
        XCTAssertEqual(viewModel.stories.count, expectedNodeCount, "There should be \(expectedNodeCount) story nodes loaded")

        XCTAssertNotNil(viewModel.currentStoryModel, "Current story model should be initialized")
        XCTAssertEqual(viewModel.currentStoryModel.id, initialStoryID, "The initial story node should be 'start'")
        XCTAssertEqual(viewModel.currentStoryModel.storyText, startNodeStoryText)
        XCTAssertEqual(viewModel.currentStoryModel.choices.count, startNodeChoicesCount)
    }

    func testMakeChoiceUpdatesCurrentNodeAndLog() {
        // This test verifies that making a choice in GamePlayViewModel updates the current story node correctly.
        // It checks that the currentStoryModel, storyLog, currentChoice, and pathHistory are all updated as expected
        // after making a choice from the initial node.
        guard let startNode = viewModel.currentStoryModel else {
            XCTFail("Initial node should be loaded")
            return
        }
        guard let stories = viewModel.stories else {
            XCTFail("Stories should be loaded")
            return
        }
        XCTAssertEqual(startNode.id, initialStoryID)
        XCTAssertFalse(startNode.choices.isEmpty, "Initial node should have choices")

        guard let firstChoice = startNode.choices.first else {
            XCTFail("Initial node should have at least one choice")
            return
        }
        let expectedNextNodeID = firstChoice.destinationID
        guard let expectedNextNode = stories[expectedNextNodeID] else {
            XCTFail("Next node should exist in stories")
            return
        }

        viewModel.makeChoice(firstChoice)

        guard let currentStoryModel = viewModel.currentStoryModel else {
            XCTFail("Current story model should not be nil after making a choice")
            return
        }
        XCTAssertEqual(currentStoryModel.id, expectedNextNodeID, "Current node should update to the destination node")
        XCTAssertEqual(viewModel.storyLog.last, "Chose: \(firstChoice.text)", "Story log should record the choice")
        XCTAssertEqual(viewModel.currentChoice, expectedNextNode.choices, "Current choices should match the next node's choices")
        XCTAssertEqual(viewModel.pathHistory.last, expectedNextNodeID, "Path history should record the new node id")
    }
}
