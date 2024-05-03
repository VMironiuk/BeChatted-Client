//
//  ChannelsViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 25.04.2024.
//

import Foundation

@Observable public final class ChannelsViewModel {
    private let channelsService: ChannelsServiceProtocol
    
    public var loadChannelsResult: Result<[ChannelItem], LoadChannelsError> = .success([])
    
    public init(channelsService: ChannelsServiceProtocol) {
        self.channelsService = channelsService
    }
    
    public func loadChannels() {
        channelsService.load { [weak self] result in
            self?.loadChannelsResult = ChannelsViewModelResultMapper.map(from: result)
        }
    }
}
