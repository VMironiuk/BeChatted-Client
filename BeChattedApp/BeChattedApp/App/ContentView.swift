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

private extension ContentView {
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


#Preview {
    ContentView()
        .environmentObject(MainNavigationController())
        .environmentObject(AppData())
}
