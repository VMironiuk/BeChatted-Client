//
//  ContentView.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 14.06.2024.
//

import AVFoundation
import SwiftUI
import BeChatted
import BeChattediOS

struct ContentView: View {
  @EnvironmentObject private var mainNavigationController: MainNavigationController
  @EnvironmentObject private var appData: AppData
  
  var body: some View {
    NavigationStack(path: $mainNavigationController.path) {
      if appData.isUserLoggedIn {
        ChannelsView(appData: appData)
      } else {
        AuthView()
      }
    }
  }
}

#Preview {
  ContentView()
    .environmentObject(MainNavigationController())
    .environmentObject(AppData())
}
