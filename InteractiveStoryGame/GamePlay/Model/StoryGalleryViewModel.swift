//
//  StoryGalleryViewModel.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/1/25.
//

import Foundation

class StoryGalleryViewModel: ObservableObject {
    @Published var stories: [StoryModel] = []

    // The file name where the stories are stored, typically in JSON format
    public init(fileName: String, bundle: Bundle = .main) {
        loadStories(fileName: fileName, bundle: bundle)
    }

    func loadStories(fileName: String, bundle: Bundle) {
        guard
            let url = bundle.url(
                forResource: fileName,
                withExtension: "json"
            )
        else {
            print("Stories manifest file not found: \(fileName).json")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let loadedStories = try decoder.decode(
                [StoryModel].self,
                from: data
            )
            self.stories = loadedStories
        } catch {
            print("Failed to load or decode stories manifest: \(error)")
        }
    }
}
