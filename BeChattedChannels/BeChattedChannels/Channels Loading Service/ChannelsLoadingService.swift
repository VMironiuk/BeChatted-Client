//
//  ChannelsLoadingService.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 09.04.2024.
//

import Combine
import Foundation

public struct ChannelInfo: Codable, Equatable {
  public let id: String
  public let name: String
  public let description: String
  
  public init(id: String, name: String, description: String) {
    self.id = id
    self.name = name
    self.description = description
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case name
    case description
  }
}

public enum ChannelsLoadingError: Error {
  case server
  case invalidData
  case connectivity
  case unknown
}

public struct ChannelsLoadingService {
  public typealias ChannelData = (id: String, name: String, description: String)
  
  private let url: URL
  private let authToken: String
  private let httpClient: HTTPClientProtocol
  private let webSocketClient: WebSocketClientProtocol
  
  public let newChannel = PassthroughSubject<ChannelData, Never>()
  
  public init(
    url: URL,
    authToken: String,
    httpClient: HTTPClientProtocol,
    webSocketClient: WebSocketClientProtocol
  ) {
    self.url = url
    self.authToken = authToken
    self.httpClient = httpClient
    self.webSocketClient = webSocketClient
    
    webSocketClient.connect()
    webSocketClient.on("channelCreated") { [weak newChannel] channelData in
      guard let channelFields = channelData as? [String], channelData.count == 3 else { return }
      newChannel?.send(
        (
          id: channelFields[2],
          name: channelFields[0],
          description: channelFields[1]
        )
      )
    }
  }
  
  public func loadChannels(completion: @escaping (Result<[ChannelInfo], ChannelsLoadingError>) -> Void) {
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    
    httpClient.perform(request: request) { result in
      switch result {
      case let .success((data, response)):
        completion(ChannelsLoadingResultMapper.result(for: data, response: response))
      case .failure:
        completion(.failure(.server))
      }
    }
  }
}
