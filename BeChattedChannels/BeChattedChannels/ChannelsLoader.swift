//
//  ChannelsLoader.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 09.04.2024.
//

import Foundation

public enum ChannelsLoaderError: Error {
    case server
    case invalidData
}

public final class ChannelsLoader {
    private let url: URL
    private let authToken: String
    private let client: HTTPClientProtocol
    
    public init(url: URL, authToken: String, client: HTTPClientProtocol) {
        self.url = url
        self.authToken = authToken
        self.client = client
    }
    
    public func load(completion: @escaping (Result<[ChannelInfo], Error>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                guard let response, response.statusCode == 200 else {
                    return completion(.failure(ChannelsLoaderError.server))
                }
                guard let data = data, let channels = try? JSONDecoder().decode([ChannelInfo].self, from: data) else {
                    return completion(.failure(ChannelsLoaderError.invalidData))
                }
                completion(.success(channels))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
