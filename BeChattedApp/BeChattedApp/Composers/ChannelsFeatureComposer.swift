//
//  ChannelsFeatureComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import BeChatted
import BeChattedChannels
import BeChattediOS
import SwiftUI

struct ChannelsFeatureComposer {
    let navigationController: MainNavigationController
    let appData: AppData
    
    var channelsView: some View {
        ChannelsViewComposer.composedChannelsView(
            with: ChannelsViewModel(
                channelsService: ChannelsServiceComposer.channelsService(with: appData.authToken ?? "")
            )
        )
    }
}
