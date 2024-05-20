//
//  ChannelsViewModelResultMapper.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 01.05.2024.
//

import Foundation

struct ChannelsViewModelResultMapper {
    private init() {}
    
    static func map(from result: Result<[Channel], ChannelsServiceError>) -> Result<[ChannelItem], ChannelsServiceError> {
        switch result {
        case .success(let channels):
            guard !channels.isEmpty else { return .success([]) }
            return .success([.title] + channels.map { .channel(name: $0.name, isUnread: false) })
        case .failure(let error):
            return .failure(error)
        }
    }
}
