//
//  ChannelCreationService_WebSocket.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 07.08.2024.
//

import Foundation

public struct ChannelCreationService_WebSocket {
  private let webSocketClient: WebSocketClientProtocol
  
  public init(webSocketClient: WebSocketClientProtocol) {
    self.webSocketClient = webSocketClient
    webSocketClient.connect()
  }
  
  public func addChannel(_ channel: CreateChanelPayload) {
    webSocketClient.emit("newChannel", channel)
  }
}
