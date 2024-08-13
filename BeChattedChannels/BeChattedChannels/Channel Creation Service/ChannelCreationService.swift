//
//  ChannelCreationService.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 07.08.2024.
//

import Foundation

public struct CreateChanelPayload {
  public let name: String
  public let description: String
  
  public init(name: String, description: String) {
    self.name = name
    self.description = description
  }
}

public struct ChannelCreationService {
  private let webSocketClient: WebSocketClientProtocol
  
  public init(webSocketClient: WebSocketClientProtocol) {
    self.webSocketClient = webSocketClient
    webSocketClient.connect()
  }
  
  public func addChannel(_ channel: CreateChanelPayload) {
    webSocketClient.emit("newChannel", channel.name, channel.description)
  }
}
