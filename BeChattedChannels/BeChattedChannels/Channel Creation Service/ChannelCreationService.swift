//
//  ChannelCreationService.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 22.05.2024.
//

import Foundation

public enum ChannelCreatingError: Error {
    case server
    case connectivity
    case unknown
}

public struct CreateChanelPayload: Encodable {
    public let name: String
    public let description: String
    
    public init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}

public final class ChannelCreationService {
    private let url: URL
    private let authToken: String
    private let client: HTTPClientProtocol
    
    public init(url: URL, authToken: String, client: HTTPClientProtocol) {
        self.url = url
        self.authToken = authToken
        self.client = client
    }
    
    public func createChannel(payload: CreateChanelPayload, completion: @escaping (Result<Void, ChannelCreatingError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(payload)
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((_, response)):
                completion(ChannelCreatingResultMapper.result(for: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
