//
//  ChannelsViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 25.04.2024.
//

import Combine

public final class ChannelsViewModel: ObservableObject {
  private let channelsLoadingService: ChannelsLoadingServiceProtocol
  private var newChannelSubscription: AnyCancellable?
  
  @Published public var loadChannelsResult: Result<[ChannelItem], ChannelsLoadingServiceError> = .success([])
  
  public init(channelsLoadingService: ChannelsLoadingServiceProtocol) {
    self.channelsLoadingService = channelsLoadingService
    
    newChannelSubscription = channelsLoadingService.newChannel.sink { [weak self] newChannel in
      guard var channels = try? self?.loadChannelsResult.get() else { return }
      channels.append(ChannelItem(id: newChannel.id, name: newChannel.name, description: newChannel.description))
      self?.loadChannelsResult = .success(channels)
    }
  }
  
  public func loadChannels() {
    channelsLoadingService.loadChannels { [weak self] result in
      DispatchQueue.main.async {
        self?.loadChannelsResult = ChannelsViewModelResultMapper.map(from: result)
      }
    }
  }
}
