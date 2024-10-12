//
//  WebSocketIOClientWrapper.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 12.10.2024.
//

import BeChattedChannels
import BeChattedMessaging
import BeChattedNetwork

struct WebSocketIOClientWrapper {
  private let underlyingWebSocketClient: WebSocketIOClient
  
  init(url: URL) {
    underlyingWebSocketClient = WebSocketIOClient(url: url)
  }
  
  func connect() {
    underlyingWebSocketClient.connect()
  }

  func disconnect() {
    underlyingWebSocketClient.disconnect()
  }
  
  func on(_ event: String, completion: @escaping ([Any]) -> Void) {
    underlyingWebSocketClient.on(event, completion: completion)
  }
}

extension WebSocketIOClientWrapper: BeChattedChannels.WebSocketClientProtocol {
  func emit(_ event: String, _ item1: String, _ item2: String) {
    underlyingWebSocketClient.emit(event, item1, item2)
  }
}

extension WebSocketIOClientWrapper: BeChattedMessaging.WebSocketClientProtocol {
  func emit(
    _ event: String,
    _ item1: String,
    _ item2: String,
    _ item3: String,
    _ item4: String,
    _ item5: String,
    _ item6: String
  ) {
    underlyingWebSocketClient.emit(
      event,
      item1,
      item2,
      item3,
      item4,
      item5,
      item6
    )
  }
}
