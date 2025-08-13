import XCTest
@testable import InteractiveStoryGame

class StoryModelTests: XCTestCase {
    // Test data for reuse
    let testStoryId = "story1"
    let testTitle = "The Lost Treasure"
    let testSynopsis = "Embark on a quest to find the legendary lost treasure hidden deep in the jungle."
    let testGalleryImageName = "treasure_map"
    let testFileName = "storyTesting.json"
    let manifestFileName = "StoriesManifestTest"
    let expectedStoryCount = 4

    func testStoryModelInitialization() {
        let story = StoryModel(
            id: testStoryId,
            title: testTitle,
            synopsis: testSynopsis,
            galleryImageName: testGalleryImageName,
            fileName: testFileName
        )
        XCTAssertEqual(story.id, testStoryId)
        XCTAssertEqual(story.title, testTitle)
        XCTAssertEqual(story.synopsis, testSynopsis)
        XCTAssertEqual(story.galleryImageName, testGalleryImageName)
        XCTAssertEqual(story.fileName, testFileName)
    }
    
    func testLoadingStoriesFromManifest() {
        guard let url = Bundle(for: type(of: self)).url(forResource: manifestFileName, withExtension: "json") else {
            XCTFail("Missing file: \(manifestFileName).json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let stories = try JSONDecoder().decode([StoryModel].self, from: data)
            
            XCTAssertEqual(stories.count, expectedStoryCount)
            
            let firstStory = stories.first
            XCTAssertNotNil(firstStory)
            XCTAssertEqual(firstStory?.id, testStoryId)
            XCTAssertEqual(firstStory?.title, testTitle)
            XCTAssertEqual(firstStory?.synopsis, testSynopsis)
            XCTAssertEqual(firstStory?.galleryImageName, testGalleryImageName)
            XCTAssertEqual(firstStory?.fileName, testFileName)
        } catch {
            XCTFail("Failed to decode \(manifestFileName).json: \(error)")
        }
    }
}
