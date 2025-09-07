
//
//  StartPageView.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/30/25.
//

import SwiftUI

// StartPageView.swift

import SwiftUI

struct StartPageView: View {
    @State private var isNewGameActive = false

    var body: some View {
        NavigationStack {
            VStack {
                // Change it to our app logo later
                Image(systemName: "book.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                StartPageButton(
                    model: StartPageButtonModel(
                        name: "New Game",
                        action: {
                            // Action to start a new game
                            print("Start New Game tapped")
                            isNewGameActive = true
                        },
                        cornerRadius: 10,
                        backgroundColor: .blue
                    )
                ).padding()

                StartPageButton(
                    model: StartPageButtonModel(
                        name: "Setting",
                        action: {
                            // Action for settings
                        },
                        cornerRadius: 10,
                        backgroundColor: .blue
                    )
                )
            }
            .navigationDestination(isPresented: $isNewGameActive) {
                GamePlayView(fileName: "storyExample", initialStoryID: "132457")
            }
        }
    }
}

#Preview {
    StartPageView()
}
