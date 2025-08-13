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
    let testNodeId = "start"
    let testStoryText = "You stand at the entrance of the jungle, map in hand. The lost treasure awaits. What will you do?"
    let testImageName = "jungle_entrance"
    let testChoices = [
        ChoiceModel(text: "Enter the jungle", hint: "Brave the unknown", destinationID: "jungle_path"),
        ChoiceModel(text: "Return home", hint: "Give up the quest", destinationID: "ending_giveup")
    ]
    let testType: StoryNodeType = .standard
    let testJSONFileName = "storyTesting"
    let expectedNodeCount = 7
    let endingNodeId = "treasure"

    func testStoryNodeInitialization() {
        let node = StoryNodeModel(
            id: testNodeId,
            storyText: testStoryText,
            imageName: testImageName,
            choices: testChoices,
            type: testType
        )
        XCTAssertEqual(node.id, testNodeId)
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
            XCTAssertEqual(nodes.count, expectedNodeCount)
            let startNode: StoryNodeModel? = nodes.first(where: { $0.id == testNodeId })
            XCTAssertNotNil(startNode)
            XCTAssertEqual(startNode?.storyText, testStoryText)
            XCTAssertEqual(startNode?.choices.count, testChoices.count)
            XCTAssertEqual(startNode?.type, testType)
            let endingNode = nodes.first(where: { $0.id == endingNodeId })
            XCTAssertNotNil(endingNode)
            XCTAssertEqual(endingNode?.type, .ending)
        } catch {
            XCTFail("Failed to decode \(testJSONFileName).json: \(error)")
        }
    }
}
