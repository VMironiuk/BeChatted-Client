//
//  ChannelsViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 25.04.2024.
//

import Foundation

@Observable public final class ChannelsViewModel {
    private let loader: ChannelsLoaderProtocol
    
    public var loadChannelsResult: Result<[ChannelItem], LoadChannelsError> = .success([])
    
    public init(loader: ChannelsLoaderProtocol) {
        self.loader = loader
    }
    
    public func loadChannels() {
        loader.load { [weak self] result in
            self?.loadChannelsResult = ChannelsViewModelResultMapper.map(from: result)
        }
    }
}
