//
//  ChannelsLoadingServiceComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 25.04.2024.
//

import BeChatted
import BeChattedChannels
import BeChattedNetwork
import Combine

struct ChannelsLoadingServiceComposer {
  private init() {}
  
  private static let baseURLString = URLProvider.baseURLString
  
  private static let endpoint = "/v1/channel"
  
  private static let url = URL(string: "\(baseURLString)\(endpoint)")!
  
  static func channelsService(with authToken: String) -> ChannelsLoadingServiceWrapper {
    ChannelsLoadingServiceWrapper(
      underlyingService: ChannelsLoadingService(
        url: url,
        authToken: authToken,
        httpClient: URLSessionHTTPClientWrapper(underlyingHTTPClient: URLSessionHTTPClient()),
        webSocketClient: WebSocketIOClientWrapper(url: URL(string: baseURLString)!)
      )
    )
  }
}

struct ChannelsLoadingServiceWrapper: ChannelsLoadingServiceProtocol {
  let underlyingService: ChannelsLoadingService
  
  var newChannel: PassthroughSubject<ChannelData, Never> {
    underlyingService.newChannel
  }
  
  func loadChannels(completion: @escaping (Result<[Channel], ChannelsLoadingServiceError>) -> Void) {
    underlyingService.loadChannels { (result: Result<[ChannelInfo], ChannelsLoadingError>) in
      switch result {
      case .success(let channelInfos):
        completion(.success(channelInfos.map { Channel(id: $0.id, name: $0.name, description: $0.description) }))
      case .failure(let error):
        completion(.failure(Self.map(from: error)))
      }
    }
  }
  
  static private func map(from channelsLoadingError: ChannelsLoadingError) -> ChannelsLoadingServiceError {
    switch channelsLoadingError {
    case .server, .connectivity:
      return .connectivity
    case .invalidData:
      return .invalidData
    case .unknown:
      return .unknown
    @unknown default:
      return .unknown
    }
  }
}
