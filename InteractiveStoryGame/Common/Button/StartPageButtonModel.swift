//
//  StartPageButtonModel.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 7/25/25.
//

import SwiftUI

struct StartPageButtonModel {
    let name: String
    let action: () -> Void
    var cornerRadius: CGFloat?
    var backgroundColor: Color
    
    init(
        name: String,
        action: @escaping () -> Void,
        cornerRadius: CGFloat? = nil,
        backgroundColor: Color = .blue
    ) {
        self.name = name
        self.action = action
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }
}
