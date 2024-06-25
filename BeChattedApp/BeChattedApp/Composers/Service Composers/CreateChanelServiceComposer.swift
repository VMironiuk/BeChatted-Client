//
//  CreateChanelServiceComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 25.05.2024.
//

import BeChatted
import BeChattedChannels
import BeChattedNetwork

struct CreateChanelServiceComposer {
  private init() {}
  
  private static let httpProtocol = "http"
  private static let host = "localhost"
  private static let port = "3005"
  private static let baseURLString = "\(httpProtocol)://\(host):\(port)"
  
  private static let endpoint = "/v1/channel/add"
  
  private static let url = URL(string: "\(baseURLString)\(endpoint)")!
  
  static func createChannelService(with authToken: String) -> ChannelCreationService {
    ChannelCreationService(url: url, authToken: authToken, client: URLSessionHTTPClient())
  }
}

extension ChannelCreationService: CreateChannelServiceProtocol {
  public func createChannel(
    withName name: String,
    description: String,
    completion: @escaping (Result<Void, BeChatted.CreateChannelServiceError>) -> Void
  ) {
    createChannel(payload: CreateChanelPayload(name: name, description: description)) { result in
      switch result {
      case .success: 
        completion(.success(()))
      case .failure(let error):
        completion(.failure(Self.map(from: error)))
      }
    }
  }
  
  static private func map(from error: ChannelCreatingError) -> CreateChannelServiceError {
    switch error {
    case .server: .server
    case .connectivity: .connectivity
    case .unknown: .unknown
    @unknown default: .unknown
    }
  }
}
