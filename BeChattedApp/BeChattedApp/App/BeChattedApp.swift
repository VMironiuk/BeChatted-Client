//
//  BeChattedApp.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 19.02.2024.
//

import AVFoundation
import BeChatted
import BeChattedAuth
import BeChattediOS
import BeChattedUserInputValidation
import SwiftUI

@main
struct BeChattedApp: App {
    @StateObject private var mainNavigationController = MainNavigationController()
    @StateObject private var appData = AppData()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $mainNavigationController.path) {
                if appData.isUserLoggedIn {
                    channelsView
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
    
    private var channelsView: some View {
        let channelsComposer = ChannelsFeatureComposer(
            navigationController: mainNavigationController,
            viewModel: channelsViewModel,
            createChannelContent: createChannelView
        )
        return channelsComposer.channelsView
    }
    
    private var createChannelView: some View {
        let createChannelComposer = CreateChannelFeatureComposer(appData: appData) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            channelsViewModel.loadChannels()
        }
        return createChannelComposer.createChannelView
    }
    
    private var channelsViewModel: ChannelsViewModel {
        ChannelsViewModel(channelsLoadingService: ChannelsLoadingServiceComposer.channelsService(with: appData.authToken ?? ""))
    }
}
