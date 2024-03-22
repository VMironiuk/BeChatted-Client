//
//  ChannelsViewComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI

public struct ChannelsViewComposer {
    private init() {}
    
    public static func composedChannelsView() -> some View {
        ChannelsView(
            channelItems: [
                ChannelItem(name: nil),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: "")])
    }
}
