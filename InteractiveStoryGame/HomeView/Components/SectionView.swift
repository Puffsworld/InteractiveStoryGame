//
//  SectionView.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/22/25.
//

import SwiftUI

struct SectionView: View {
  let title: String
  let items: [GalleryCellViewModel]
  let onTap: (GalleryCellViewModel) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(title)
        .font(.headline)
        .foregroundColor(.white)
        .padding(.horizontal)

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
          ForEach(items) { item in
            GameCard(viewModel: item)
              .onTapGesture {
                onTap(item)
              }
          }
        }
        .padding(.horizontal)
      }
    }
  }
}

#Preview {
  let mockItems = [
    StoryModel(
      id: "1", title: "Story A", synopsis: "Desc A", galleryImageName: "", fileName: "",
      initialStoryID: "start", category: .topPick, progress: 0),
    StoryModel(
      id: "2", title: "Story B", synopsis: "Desc B", galleryImageName: "", fileName: "",
      initialStoryID: "start", category: .topPick, progress: 0),
  ].map { GalleryCellViewModel(storyModel: $0) }

  SectionView(title: "Mock Section", items: mockItems, onTap: { _ in })
    .preferredColorScheme(.dark)
}
