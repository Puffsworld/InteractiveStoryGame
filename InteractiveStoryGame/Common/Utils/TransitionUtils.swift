//
//  TransitionUtils.swift
//  InteractiveStoryGame
//
//  Created for GamePlay Animations
//

import SwiftUI

extension AnyTransition {
  /// A custom transition that fades in/out and slides slightly up.
  /// - Parameters:
  ///   - offset: The vertical distance to slide (default is 10).
  /// - Returns: A transition combining opacity and offset.
  /// A transition that fades in and slides up (Insertion Only).
  static var slideUpFadeIn: AnyTransition {
    AnyTransition.modifier(
      active: SlideUpFadeModifier(opacity: 0, yOffset: 5),
      identity: SlideUpFadeModifier(opacity: 1, yOffset: 0)
    )
  }

  /// The full asymmetric transition (Standard)
  static var slideUpFade: AnyTransition {
    .asymmetric(insertion: slideUpFadeIn, removal: slideUpFadeIn)
  }
}

/// A ViewModifier that applies opacity and vertical offset.
struct SlideUpFadeModifier: ViewModifier {
  let opacity: Double
  let yOffset: CGFloat

  func body(content: Content) -> some View {
    content
      .opacity(opacity)
      .offset(y: yOffset)
  }
}
