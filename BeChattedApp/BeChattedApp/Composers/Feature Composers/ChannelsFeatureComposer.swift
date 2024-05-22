//
//  ChannelsFeatureComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI

import BeChatted
import BeChattedChannels
import BeChattediOS

struct ChannelsFeatureComposer {
    let navigationController: MainNavigationController
    let appData: AppData
    
    var channelsView: some View {
        ChannelsViewComposer.composedChannelsView(
            with: ChannelsViewModel(
                channelsLoadingService: ChannelsLoadingServiceComposer.channelsService(with: appData.authToken ?? "")
            )
        )
    }
}
