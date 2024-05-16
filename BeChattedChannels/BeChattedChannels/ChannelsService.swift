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

public struct ChannelsServiceConfiguration {
    public let loadChannelsURL: URL
    public let createChannelURL: URL
    public let authToken: String
    
    public init(loadChannelsURL: URL, createChannelURL: URL, authToken: String) {
        self.loadChannelsURL = loadChannelsURL
        self.createChannelURL = createChannelURL
        self.authToken = authToken
    }
}

public struct CreateChanelPayload: Encodable {
    public let name: String
    public let description: String
    
    public init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}

public final class ChannelsService {
    private let configuration: ChannelsServiceConfiguration
    private let client: HTTPClientProtocol
    
    public init(configuration: ChannelsServiceConfiguration, client: HTTPClientProtocol) {
        self.configuration = configuration
        self.client = client
    }
    
    public func loadChannels(completion: @escaping (Result<[ChannelInfo], ChannelsLoadingError>) -> Void) {
        var request = URLRequest(url: configuration.loadChannelsURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(configuration.authToken)", forHTTPHeaderField: "Authorization")
        
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
    
    public func createChannel(payload: CreateChanelPayload, completion: @escaping (Result<Void, ChannelsLoadingError>) -> Void) {
        var request = URLRequest(url: configuration.createChannelURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(configuration.authToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(payload)
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((_, response)) where response?.statusCode == 200:
                completion(.success(()))
            case .failure:
                completion(.failure(.server))
            default:
                completion(.failure(.server))
            }
        }
    }
}
