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
  static func makeChannelCreationService() -> ChannelCreationService {
    ChannelCreationService(
      webSocketClient: WebSocketIOClient(
        url: URL(string: URLProvider.baseURLString)!
      )
    )
  }
}

extension ChannelCreationService: @retroactive CreateChannelServiceProtocol {
  public func addChannel(withName name: String, description: String) {
    addChannel(CreateChanelPayload(name: name, description: description))
  }
}
