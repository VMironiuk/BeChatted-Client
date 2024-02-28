//
//  BeChattedApp.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 19.02.2024.
//

import BeChatted
import BeChattedAuth
import BeChattediOS
import BeChattedUserInputValidation
import SwiftUI

@Observable final class AppData {
    var isUserLoggedIn: Bool = false
}

@main
struct BeChattedApp: App {
    @Bindable private var mainNavigationController = MainNavigationController()
    @Bindable private var appData = AppData()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $mainNavigationController.path) {
                if appData.isUserLoggedIn {
                    Text("Chat View is Under Construction...")
                } else {
                    loginView
                        .navigationDestination(for: MainNavigationController.Destination.self) { destination in
                            registerView
                        }
                }
            }
        }
    }
}

private extension BeChattedApp {
    private var loginView: some View {
        let loginComposer = LoginFeatureComposer(navigationController: mainNavigationController, appData: appData)
        return loginComposer.loginView
    }
    
    private var registerView: some View {
        let registerComposer = RegisterFeatureComposer(navigationController: mainNavigationController)
        return registerComposer.registerView
    }
}
