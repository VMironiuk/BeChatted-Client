//
//  WebSocketIOClient.swift
//  BeChattedNetwork
//
//  Created by Volodymyr Myroniuk on 30.07.2024.
//

import Foundation
import SocketIO

public struct WebSocketIOClient {
  private let socketManager: SocketManager
  private let socket: SocketIOClient
  
  public init(socketManager: SocketManager) {
    self.socketManager = socketManager
    self.socket = socketManager.defaultSocket
  }
  
  public init(url: URL) {
    self.init(
      socketManager: SocketManager(
        socketURL: url,
        config: [.log(true), .compress, .forceWebsockets(true)])
    )
  }
  
  public func connect() {
    socket.connect()
  }
  
  public func disconnect() {
    socket.disconnect()
  }
  
  public func emit(_ event: String, _ item1: String, _ item2: String) {
    socket.emit(event, item1, item2)
  }
  
  public func emit(
    _ event: String,
    _ item1: String,
    _ item2: String,
    _ item3: String,
    _ item4: String,
    _ item5: String,
    _ item6: String
  ) {
    socket.emit(event, item1, item2, item3, item4, item5, item6)
  }
  
  public func on(_ event: String, completion: @escaping ([Any]) -> Void) {
    socket.on(event) { items, _ in
      completion(items)
    }
  }
}
