//
//  ChannelsLoaderComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 25.04.2024.
//

import BeChatted
import BeChattedChannels
import BeChattediOS

struct ChannelsLoaderComposer {
    private init() {}
    
    private static let httpProtocol = "http"
    private static let host = "localhost"
    private static let port = "3005"
    private static let baseURLString = "\(httpProtocol)://\(host):\(port)"

    private static let channelsEndpoint = "/v1/channel"
    
    private static let channelsURL = URL(string: "\(baseURLString)\(channelsEndpoint)")!
    
    static func channelsLoader(with authToken: String) -> ChannelsLoader {
        ChannelsLoader(url: channelsURL, authToken: authToken, client: URLSessionHTTPClient())
    }
}

extension ChannelsLoader: BeChattediOS.ChannelsLoaderProtocol {
    public func load(completion: @escaping (Result<[BeChattediOS.Channel], BeChattediOS.LoadChannelsError>) -> Void) {
        load { (result: Result<[ChannelInfo], ChannelsLoaderError>) in
            switch result {
            case .success(let channelInfos):
                completion(.success(channelInfos.map { Channel(id: $0.id, name: $0.name, description: $0.description) }))
            case .failure(let loaderError):
                completion(.failure(Self.map(from: loaderError)))
            }
        }
    }
    
    static private func map(from loaderError: ChannelsLoaderError) -> BeChattediOS.LoadChannelsError {
        switch loaderError {
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

extension URLSessionHTTPClient: HTTPClientProtocol {}
