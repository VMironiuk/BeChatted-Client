//
//  WebSocketClientProtocol.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 03.08.2024.
//

import Foundation

public protocol WebSocketClientProtocol {
  init(url: URL)
  func connect()
  func disconnect()
  // Because of shitty implementation on server side, which
  // cannot handle arrays this piece of shit for emitting is mandatory
  func emit(_ event: String, _ item1: String, _ item2: String)
  func on(_ event: String, completion: @escaping ([Any]) -> Void)
}
