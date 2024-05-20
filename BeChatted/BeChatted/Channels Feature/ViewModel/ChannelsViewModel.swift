//
//  ChannelsViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 25.04.2024.
//

import Foundation

@Observable public final class ChannelsViewModel {
    private let channelsService: ChannelsServiceProtocol
    
    public var loadChannelsResult: Result<[ChannelItem], ChannelsServiceError> = .success([])
    
    public init(channelsService: ChannelsServiceProtocol) {
        self.channelsService = channelsService
    }
    
    public func loadChannels() {
        channelsService.loadChannels { [weak self] result in
            self?.loadChannelsResult = ChannelsViewModelResultMapper.map(from: result)
        }
    }
    
    public func createChannel(withName name: String, description: String) {
        channelsService.createChannel(withName: name, description: description) { [weak self] result in
            switch result {
            case .success:
                self?.loadChannels()
            case .failure:
                break
            }
        }
    }
}
