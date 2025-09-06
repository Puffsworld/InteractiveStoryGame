//
//  StoryNodeModelTest.swift
//  InteractiveStoryGameTests
//
//  Created by wentao li on 8/3/25.
//

import XCTest
@testable import InteractiveStoryGame

class StoryNodeModelTest: XCTestCase {
    // Test data for reuse
    let testNodeId = "132457"
    let testNodeLoggingId = "Start"
    let testStoryText = "A deep alarm rumbles through the Aegis. The bridge is empty, save for you, the sole engineer. The ship's AI, \"Orion,\" is silent. A main system failure flickers on your terminal."
    let testImageName = "lonely_starship_bridge"
    let testChoices = [
        ChoiceModel(text: "Try to reboot Orion.", hint: "The AI might have a clue.", destinationID: "298765"),
        ChoiceModel(text: "Check the external diagnostics.", hint: "What's happening outside the ship?", destinationID: "476890")
    ]
    let testType: StoryNodeType = .standard
    let testJSONFileName = "storyTesting"
    let expectedNodeCount = 9
    let endingNodeId = "785432"

    func testStoryNodeInitialization() {
        let node = StoryNodeModel(
            id: testNodeId,
            loggingID: testNodeLoggingId,
            storyText: testStoryText,
            imageName: testImageName,
            choices: testChoices,
            type: testType
        )
        XCTAssertEqual(node.id, testNodeId)
        XCTAssertEqual(node.loggingID, testNodeLoggingId)
        XCTAssertEqual(node.storyText, testStoryText)
        XCTAssertEqual(node.imageName, testImageName)
        XCTAssertEqual(node.choices.count, testChoices.count)
        XCTAssertEqual(node.type, testType)
    }
    
    func testLoadStoryNodesFromJSON() {
        guard let url = Bundle(for: type(of: self)).url(forResource: testJSONFileName, withExtension: "json") else {
            XCTFail("Missing file: \(testJSONFileName).json")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let nodes: [StoryNodeModel] = try JSONDecoder().decode([StoryNodeModel].self, from: data)
            XCTAssertFalse(nodes.isEmpty, "Decoded nodes should not be empty")
            XCTAssertEqual(nodes.count, expectedNodeCount)
            let startNode: StoryNodeModel? = nodes.first(where: { $0.id == testNodeId })
            XCTAssertNotNil(startNode, "Start node should not be nil")
            XCTAssertEqual(startNode?.loggingID, testNodeLoggingId)
            XCTAssertEqual(startNode?.storyText, testStoryText)
            XCTAssertEqual(startNode?.choices.count, testChoices.count)
            XCTAssertEqual(startNode?.type, testType)
            let endingNode = nodes.first(where: { $0.id == endingNodeId })
            XCTAssertNotNil(endingNode, "Ending node should not be nil")
            XCTAssertEqual(endingNode?.type, StoryNodeType.ending)
        } catch {
            XCTFail("Failed to decode \(testJSONFileName).json: \(error)")
        }
    }
}
