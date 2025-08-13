import XCTest
@testable import InteractiveStoryGame

class StoryGalleryViewModelTest: XCTestCase {

    var viewModel: StoryGalleryViewModel!
    let testFileName = "StoriesManifestTest"
    let expectedStoryCount = 4
    let firstStoryId = "story1"
    let firstStoryTitle = "The Lost Treasure"
    let firstStorySynopsis = "Embark on a quest to find the legendary lost treasure hidden deep in the jungle."
    let firstStoryGalleryImageName = "treasure_map"
    let firstStoryFileName = "storyTesting.json"

    override func setUp() {
        super.setUp()
        // The view model's initializer loads the stories.
        // We must ensure it can find the test file in the test bundle.
        viewModel = StoryGalleryViewModel(fileName: testFileName, bundle: Bundle(for: type(of: self)))
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testLoadStoriesFromManifest() {
        // Test that the stories array is populated
        XCTAssertNotNil(viewModel.stories, "Stories should be loaded and not nil")
        XCTAssertEqual(viewModel.stories.count, expectedStoryCount, "There should be \(expectedStoryCount) stories loaded from the manifest")

        // Test the content of the first story
        let firstStory = viewModel.stories.first
        XCTAssertNotNil(firstStory, "The stories array should not be empty")
        XCTAssertEqual(firstStory?.id, firstStoryId)
        XCTAssertEqual(firstStory?.title, firstStoryTitle)
        XCTAssertEqual(firstStory?.synopsis, firstStorySynopsis)
        XCTAssertEqual(firstStory?.galleryImageName, firstStoryGalleryImageName)
        XCTAssertEqual(firstStory?.fileName, firstStoryFileName)
    }
}
