//
//  ChannelsViewModelResultMapper.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 01.05.2024.
//

import Foundation

enum ChannelsViewModelResultMapper {
    static func map(from result: Result<[Channel], ChannelsLoadingServiceError>) -> Result<[ChannelItem], ChannelsLoadingServiceError> {
        switch result {
        case .success(let channels): .success(channels.map { .init(id: $0.id, name: $0.name) })
        case .failure(let error): .failure(error)
        }
    }
}
