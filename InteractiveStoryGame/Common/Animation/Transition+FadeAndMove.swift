//  Transition+FadeAndMove.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 9/8/25.
//
import SwiftUI

extension AnyTransition {
    // Custom transition that combines fade and move effects
    static var fadeAndMove: AnyTransition {
        let removal = AnyTransition.opacity.animation(.easeIn(duration: 0.2))
        let insertion = AnyTransition.opacity.animation(.easeIn(duration: 0.2).delay(0.2))
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var instantRemoval: AnyTransition {
            let removal = AnyTransition.identity
            let insertion = AnyTransition.opacity.animation(.easeIn(duration: 0.2))
            return .asymmetric(insertion: insertion, removal: removal)
        }
}
