//
//  ChannelsServiceComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 25.04.2024.
//

import BeChatted
import BeChattedChannels
import BeChattedNetwork

struct ChannelsServiceComposer {
    private init() {}
    
    private static let httpProtocol = "http"
    private static let host = "localhost"
    private static let port = "3005"
    private static let baseURLString = "\(httpProtocol)://\(host):\(port)"

    private static let channelsEndpoint = "/v1/channel"
    
    private static let channelsURL = URL(string: "\(baseURLString)\(channelsEndpoint)")!
    
    static func channelsService(with authToken: String) -> ChannelsService {
        ChannelsService(url: channelsURL, authToken: authToken, client: URLSessionHTTPClient())
    }
}

extension ChannelsService: ChannelsServiceProtocol {
    public func load(completion: @escaping (Result<[Channel], LoadChannelsError>) -> Void) {
        load { (result: Result<[ChannelInfo], ChannelsLoadingError>) in
            switch result {
            case .success(let channelInfos):
                completion(.success(channelInfos.map { Channel(id: $0.id, name: $0.name, description: $0.description) }))
            case .failure(let error):
                completion(.failure(Self.map(from: error)))
            }
        }
    }
    
    static private func map(from channelsLoadingError: ChannelsLoadingError) -> LoadChannelsError {
        switch channelsLoadingError {
        case .server:
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
