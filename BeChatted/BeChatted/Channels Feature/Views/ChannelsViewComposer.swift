//
//  ChannelsViewComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI
import BeChatted

public struct ChannelsViewComposer {
    private init() {}
    
    public static func composedChannelsView(with viewModel: ChannelsViewModel, createChannelContent: some View) -> some View {
        ChannelsView(/*viewModel: viewModel, */createChannelContent: createChannelContent)
    }
}
