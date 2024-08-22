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
  func emit(_ event: String, _ item1: String, _ item2: String)
  func on(_ event: String, completion: @escaping ([Any]) -> Void)
}
