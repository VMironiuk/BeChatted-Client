//
//  CreateChannelServiceComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 10.08.2024.
//

import BeChatted
import BeChattedChannels
import BeChattedNetwork

enum CreateChannelServiceComposer {
  static func makeChannelCreationService() -> ChannelCreationServiceWrapper {
    ChannelCreationServiceWrapper(
      underlyingService: ChannelCreationService(
        webSocketClient: WebSocketIOClient(
          url: URL(string: URLProvider.baseURLString)!
        )
      )
    )
  }
}

struct ChannelCreationServiceWrapper: CreateChannelServiceProtocol {
  let underlyingService: ChannelCreationService
  
  func addChannel(withName name: String, description: String) {
    underlyingService.addChannel(CreateChanelPayload(name: name, description: description))
  }
}
