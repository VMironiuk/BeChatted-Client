//
//  ChannelsLoadingService.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 09.04.2024.
//

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
  private let url: URL
  private let authToken: String
  private let client: HTTPClientProtocol
  
  public init(url: URL, authToken: String, client: HTTPClientProtocol) {
    self.url = url
    self.authToken = authToken
    self.client = client
  }
  
  public func loadChannels(completion: @escaping (Result<[ChannelInfo], ChannelsLoadingError>) -> Void) {
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    
    client.perform(request: request) { result in
      switch result {
      case let .success((data, response)):
        completion(ChannelsLoadingResultMapper.result(for: data, response: response))
      case .failure:
        completion(.failure(.server))
      }
    }
  }    
}
