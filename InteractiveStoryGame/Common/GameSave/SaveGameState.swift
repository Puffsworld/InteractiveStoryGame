import Foundation

struct SavedGameState: Codable {
  // Schema version for future save migrations.
  let version: Int

  // Unique identifier for the whole story.
  let storyID: String

  // Human-readable path for developer analysis.
  let pathHistory: [String]

  // Machine-readable path used to restore the current story node.
  let nodePathHistory: [String]

  // Date when the game was saved.
  let savedAt: Date

  // The current node is always the final node in the saved path.
  var currentNodeID: String? {
    nodePathHistory.last
  }
}
