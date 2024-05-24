//
//  ChannelsLoadingServiceComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 25.04.2024.
//

import BeChatted
import BeChattedChannels
import BeChattedNetwork

struct ChannelsLoadingServiceComposer {
    private init() {}
    
    private static let httpProtocol = "http"
    private static let host = "localhost"
    private static let port = "3005"
    private static let baseURLString = "\(httpProtocol)://\(host):\(port)"

    private static let endpoint = "/v1/channel"
    
    private static let url = URL(string: "\(baseURLString)\(endpoint)")!
    
    static func channelsService(with authToken: String) -> ChannelsLoadingService {
        ChannelsLoadingService(url: url, authToken: authToken, client: URLSessionHTTPClient())
    }
}

extension ChannelsLoadingService: ChannelsLoadingServiceProtocol {
    public func loadChannels(completion: @escaping (Result<[Channel], ChannelsLoadingServiceError>) -> Void) {
        loadChannels { (result: Result<[ChannelInfo], ChannelsLoadingError>) in
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