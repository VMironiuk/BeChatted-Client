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
    self.init(socketManager: SocketManager(socketURL: url, config: [.log(true), .compress]))
  }
  
  public func connect() {
    socket.connect()
  }
  
  public func disconnect() {
    socket.disconnect()
  }
  
  public func emit(_ event: String, _ items: Any...) {
    socket.emit(event, items)
  }
  
  public func on(_ event: String, completion: @escaping ([Any]) -> Void) {
    socket.on(event) { items, _ in
      completion(items)
    }
  }
}
