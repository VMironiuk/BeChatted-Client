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
                ChannelItem(name: nil, isUnread: false),
                ChannelItem(name: "general", isUnread: false),
                ChannelItem(name: "announcements", isUnread: true),
                ChannelItem(name: "main", isUnread: false),
                ChannelItem(name: "random", isUnread: true),
                ChannelItem(name: "onboarding", isUnread: false)])
    }
}
