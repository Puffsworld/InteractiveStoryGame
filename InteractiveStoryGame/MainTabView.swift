//
//  MainTabView.swift
//  InteractiveStoryGame
//
//  Created for Homepage Modernization
//

import SwiftUI

struct MainTabView: View {
  var body: some View {
    TabView {
      HomeView()
        .tabItem {
          Label("Home", systemImage: "house.fill")
        }

      Text("Library Placeholder")
        .tabItem {
          Label("Library", systemImage: "books.vertical.fill")
        }

      Text("Profile Placeholder")
        .tabItem {
          Label("Profile", systemImage: "person.fill")
        }
    }
    // Ensure TabBar is visible and styled for dark mode
    .toolbarBackground(.visible, for: .tabBar)
    .preferredColorScheme(.dark)
  }
}

#Preview {
  MainTabView()
}
