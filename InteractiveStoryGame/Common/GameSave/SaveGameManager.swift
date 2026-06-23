//
//  SaveGameManager.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 6/22/26.
//

import Foundation

protocol SaveGameManager {
    func save(_ save:SavedGameState)
    func load(storyID:String) -> SavedGameState?
    func hasGameSaved(storyID:String) -> Bool
    func delete(storyID:String)
}

final class UserDefaultSaveGameManager: SaveGameManager {
    private let defaults: UserDefaults
    init (defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func save(_ save: SavedGameState) {
    }
    
    func load(storyID: String) -> SavedGameState? {
        return nil
    }
    
    func hasGameSaved(storyID: String) -> Bool {
        return false
    }
    
    func delete(storyID: String) {
        
    }
    
}
