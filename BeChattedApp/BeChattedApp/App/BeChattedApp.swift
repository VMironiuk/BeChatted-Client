//
//  BeChattedApp.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 19.02.2024.
//

import SwiftUI

@main
struct BeChattedApp: App {
  @StateObject private var mainNavigationController = MainNavigationController()
  @StateObject private var appData = AppData()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(mainNavigationController)
        .environmentObject(appData)
    }
  }
}
