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

struct ChannelsFeatureComposer<Content: View> {
    let navigationController: MainNavigationController
    let viewModel: ChannelsViewModel
    let createChannelContent: Content
    
    var channelsView: some View {
        ChannelsViewComposer.composedChannelsView(
            with: viewModel,
            createChannelContent: createChannelContent
        )
    }
}
