//
//  HomeView.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/22/25.
//

import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel = HomeViewModel()
  @State private var selectedGame: GamePlayViewModel?
  @State private var isGamePresented = false

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 24) {
          if let featured = viewModel.featuredStory {
            FeaturedGameCard(viewModel: featured) {
              resumeGame(with: featured)
            }
          }

          SectionView(title: "Top Picks for You", items: viewModel.topPicks) { item in
            resumeGame(with: item)
          }

          SectionView(title: "Quick Reads", items: viewModel.quickReads) { item in
            resumeGame(with: item)
          }
        }
        .padding(.bottom, 20)
      }
      .background(Color.black.ignoresSafeArea())
      .navigationTitle("")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Text("Project Odyssey")  // Only used as Title if needed, or remove
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
        }
      }
      .navigationDestination(isPresented: $isGamePresented) {
        if let gameVM = selectedGame {
          GamePlayView(viewModel: gameVM)
        }
      }
    }.preferredColorScheme(.dark)
  }

  private func resumeGame(with item: GalleryCellViewModel) {
    self.selectedGame = item.createGamePlayViewModel()
    self.isGamePresented = true
  }
}

#Preview {
  HomeView()
}
