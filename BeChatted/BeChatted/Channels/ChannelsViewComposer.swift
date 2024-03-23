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
                .title,
                .channel(name: "general", isUnread: false),
                .channel(name: "announcements", isUnread: true),
                .channel(name: "main", isUnread: false),
                .channel(name: "random", isUnread: true),
                .channel(name: "onboarding", isUnread: false)])
    }
}
