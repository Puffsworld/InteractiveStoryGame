//
//  GameCard.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/22/25.
//

import SwiftUI

struct GameCard: View {
  @ObservedObject var viewModel: GalleryCellViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Rectangle()
        .fill(Color.gray.opacity(0.3))
        .frame(width: 140, height: 100)
        .cornerRadius(8)
        .overlay(
          Text(viewModel.title.prefix(1)).font(.largeTitle).foregroundColor(.white.opacity(0.2)))

      Text(viewModel.title)
        .font(.caption)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .lineLimit(1)

      Text(viewModel.synopsis)
        .font(.caption2)
        .foregroundColor(.gray)
        .lineLimit(1)
    }
    .frame(width: 140)
  }
}

#Preview {
  let mockMetaData = StoryModel(
    id: "mock_2",
    title: "Tiny Adventure",
    synopsis: "Short but sweet.",
    galleryImageName: "",
    fileName: "",
    initialStoryID: "start",
    category: .topPick,
    progress: 0.0
  )
  let vm = GalleryCellViewModel(storyModel: mockMetaData)

  GameCard(viewModel: vm)
    .preferredColorScheme(.dark)
}
