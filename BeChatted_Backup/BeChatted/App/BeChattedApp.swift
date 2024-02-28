//
//  BeChattedApp.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.11.2023.
//

import SwiftUI

@main
struct BeChattedApp: App {
    @ObservedObject private var mainNavigationController = MainNavigationController()
    private var appData = AppData()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $mainNavigationController.path) {
                ContentView()
                    .environmentObject(appData)
                    .addKeyboardVisibilityToEnvironment()
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case .register: RegisterViewComposer().registerView.addKeyboardVisibilityToEnvironment()
                        }
                    }
            }
            .environmentObject(mainNavigationController)
        }
    }
}
