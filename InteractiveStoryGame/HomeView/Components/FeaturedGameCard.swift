//
//  FeaturedGameCard.swift
//  InteractiveStoryGame
//
//  Created by wentao li on 8/22/25.
//

import SwiftUI

struct FeaturedGameCard: View {
  @ObservedObject var viewModel: GalleryCellViewModel
  var onResume: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Placeholder for Image
      Rectangle()
        .fill(Color.gray.opacity(0.3))
        .aspectRatio(16 / 9, contentMode: .fit)
        .overlay(
          Image(systemName: "gamecontroller.fill")  // Fallback
            .resizable()
            .scaledToFit()
            .frame(width: 50)
            .foregroundColor(.white.opacity(0.5))

        )
        .cornerRadius(12)

      VStack(alignment: .leading, spacing: 12) {
        // Progress Bar
        if viewModel.progress > 0 {
          ProgressView(value: viewModel.progress)
            .tint(.purple)
            .background(Color.gray.opacity(0.3))
        }

        Button(action: onResume) {
          Text("RESUME")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.purple)
            .cornerRadius(25)
        }
      }
      .padding(16)
      .background(Color(UIColor.systemGray6).opacity(0.2))
      .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
    }
    .padding(.horizontal)
  }
}

// Helper for corner radius
extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect, byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

#Preview {
  let mockMetaData = StoryModel(
    id: "mock_1",
    title: "Project Mock",
    synopsis: "A mock story.",
    galleryImageName: "",
    fileName: "",
    initialStoryID: "start",
    category: .featured,
    progress: 0.7
  )
  let vm = GalleryCellViewModel(storyModel: mockMetaData)

  FeaturedGameCard(viewModel: vm, onResume: {})
    .preferredColorScheme(.dark)
}
