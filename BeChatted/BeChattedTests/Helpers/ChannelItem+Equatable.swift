//
//  ChannelItem+Equatable.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 20.05.2024.
//

import BeChatted

extension ChannelItem: Equatable {
    public static func == (lhs: ChannelItem, rhs: ChannelItem) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
