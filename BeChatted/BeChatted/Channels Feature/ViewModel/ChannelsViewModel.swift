//
//  ChannelsViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 25.04.2024.
//

import Foundation

@Observable public final class ChannelsViewModel {
    private let channelsLoadingService: ChannelsLoadingServiceProtocol
    
    public var loadChannelsResult: Result<[ChannelItem], ChannelsLoadingServiceError> = .success([])
    
    public init(channelsLoadingService: ChannelsLoadingServiceProtocol) {
        self.channelsLoadingService = channelsLoadingService
    }
    
    public func loadChannels() {
        channelsLoadingService.loadChannels { [weak self] result in
            self?.loadChannelsResult = ChannelsViewModelResultMapper.map(from: result)
        }
    }
}
