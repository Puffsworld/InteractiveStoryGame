//
//  SwiftUIView.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 7/25/25.
//

import SwiftUI

struct StartPageButton: View {
    let model: StartPageButtonModel

    init(model: StartPageButtonModel) {
        self.model = model
    }

    var body: some View {
        Button(action: model.action) {
            Text(model.name)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                .background(model.backgroundColor)
                .cornerRadius(model.cornerRadius ?? 8)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Default button
        StartPageButton(
            model: StartPageButtonModel(
                name: "Start Game",
                action: { print("Start Game tapped") }
            )).padding()

        // Custom corner radius
        StartPageButton(
            model: StartPageButtonModel(
                name: "Settings",
                action: { print("Settings tapped") },
                cornerRadius: 20,
                backgroundColor: .green
            ))
    }
    .padding()
    StartPageButton(model: StartPageButtonModel(name: "About US", action:{print("click about us")}, cornerRadius: 20))
        .padding()
        
}
