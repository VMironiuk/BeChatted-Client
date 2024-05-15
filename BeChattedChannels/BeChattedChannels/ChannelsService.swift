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
    private let loadURL: URL
    private let createURL: URL
    private let authToken: String
    private let client: HTTPClientProtocol
    
    public init(loadURL: URL, createURL: URL, authToken: String, client: HTTPClientProtocol) {
        self.loadURL = loadURL
        self.createURL = createURL
        self.authToken = authToken
        self.client = client
    }
    
    public func load(completion: @escaping (Result<[ChannelInfo], ChannelsLoadingError>) -> Void) {
        var request = URLRequest(url: loadURL)
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
    
    public func create(with name: String, description: String, completion: @escaping (Result<Void, ChannelsLoadingError>) -> Void) {
        var request = URLRequest(url: createURL)
        
        client.perform(request: request) { _ in }
    }
}
