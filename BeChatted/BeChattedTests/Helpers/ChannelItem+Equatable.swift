//
//  ChannelItem+Equatable.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 20.05.2024.
//

import BeChatted

extension ChannelItem: Equatable {
    public static func == (lhs: ChannelItem, rhs: ChannelItem) -> Bool {
        switch (lhs, rhs) {
        case (.title, .title):
            return true
        case let (.channel(lhsName, lhsIsUnread), .channel(rhsName, rhsIsUnread)):
            return lhsName == rhsName && lhsIsUnread == rhsIsUnread
        default:
            return false
        }
    }
}
