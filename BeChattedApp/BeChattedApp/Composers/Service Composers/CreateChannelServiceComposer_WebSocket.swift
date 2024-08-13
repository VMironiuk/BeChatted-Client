//
//  CreateChannelServiceComposer_WebSocket.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 10.08.2024.
//

import BeChatted
import BeChattedChannels
import BeChattedNetwork

enum CreateChannelServiceComposer_WebSocket {
  static func makeChannelCreationService() -> ChannelCreationService_WebSocket {
    ChannelCreationService_WebSocket(
      webSocketClient: WebSocketIOClient(
        url: URL(string: URLProvider.baseURLString)!
      )
    )
  }
}

extension ChannelCreationService_WebSocket: CreateChannelServiceProtocol_WebSocket {
  public func addChannel(withName name: String, description: String) {
    addChannel(CreateChanelPayload(name: name, description: description))
  }
}
