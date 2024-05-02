//
//  ChannelsService.swift
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
    case unknown
}

public protocol HTTPClientProtocol {
    func perform(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void)
}

public final class ChannelsService {
    private let url: URL
    private let authToken: String
    private let client: HTTPClientProtocol
    
    public init(url: URL, authToken: String, client: HTTPClientProtocol) {
        self.url = url
        self.authToken = authToken
        self.client = client
    }
    
    public func load(completion: @escaping (Result<[ChannelInfo], ChannelsLoadingError>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(ChannelsLoadingResultMapper.result(for: data, response: response))
            case .failure:
                completion(.failure(.server))
            }
        }
    }
}
