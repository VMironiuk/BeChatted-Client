//
//  ChannelItem.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 01.05.2024.
//

import Foundation

public enum ChannelItem: Identifiable {
    public var id: UUID { UUID() }
    case title
    case channel(name: String, isUnread: Bool)
}
