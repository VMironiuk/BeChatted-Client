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

    private static let loadChannelsEndpoint = "/v1/channel"
    private static let createChannelEndpoint = "/v1/channel/add"
    
    private static let loadChannelsURL = URL(string: "\(baseURLString)\(loadChannelsEndpoint)")!
    private static let createChannelURL = URL(string: "\(baseURLString)\(createChannelEndpoint)")!
    
    static func channelsService(with authToken: String) -> ChannelsService {
        let configuration = ChannelsServiceConfiguration(
            loadChannelsURL: loadChannelsURL,
            createChannelURL: createChannelURL,
            authToken: authToken)
        return ChannelsService(configuration: configuration, client: URLSessionHTTPClient())
    }
}

extension ChannelsService: ChannelsServiceProtocol {
    public func load(completion: @escaping (Result<[Channel], ChannelsServiceError>) -> Void) {
        loadChannels { (result: Result<[ChannelInfo], ChannelsLoadingError>) in
            switch result {
            case .success(let channelInfos):
                completion(.success(channelInfos.map { Channel(id: $0.id, name: $0.name, description: $0.description) }))
            case .failure(let error):
                completion(.failure(Self.map(from: error)))
            }
        }
    }
    
    public func createChannel(withName name: String, description: String, completion: @escaping (Result<Void, ChannelsServiceError>) -> Void) {
    }
    
    static private func map(from channelsLoadingError: ChannelsLoadingError) -> ChannelsServiceError {
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
