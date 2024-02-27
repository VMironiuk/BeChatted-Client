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

@main
struct BeChattedApp: App {
    @Bindable private var mainNavigationController = MainNavigationController()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $mainNavigationController.path) {
                loginView
                    .navigationDestination(for: MainNavigationController.Destination.self) { destination in
                        registerView
                    }
            }
        }
    }
}

private extension BeChattedApp {
    private var loginView: some View {
        let loginComposer = LoginFeatureComposer(navigationController: mainNavigationController)
        return loginComposer.loginView
    }
    
    private var registerView: some View {
        let registerComposer = RegisterFeatureComposer(navigationController: mainNavigationController)
        return registerComposer.registerView
    }
}
