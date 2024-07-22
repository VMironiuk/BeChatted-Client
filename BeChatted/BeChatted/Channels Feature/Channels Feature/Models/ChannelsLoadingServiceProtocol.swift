//
//  ChannelsLoadingServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 01.05.2024.
//

import Foundation

public struct Channel {
  public let id: String
  public let name: String
  public let description: String
  
  public init(id: String, name: String, description: String) {
    self.id = id
    self.name = name
    self.description = description
  }
}

public enum ChannelsLoadingServiceError: Error {
  case unknown
  case connectivity
  case invalidData
}

public protocol ChannelsLoadingServiceProtocol {
  func loadChannels(completion: @escaping (Result<[Channel], ChannelsLoadingServiceError>) -> Void)
}
