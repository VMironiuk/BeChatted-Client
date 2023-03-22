//
//  NewAccountService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 24.02.2023.
//

import Foundation

public final class NewAccountService: NewAccountServiceProtocol {
    private let url: URL
    private let client: HTTPClientProtocol
    
    public enum Error: Swift.Error {
        case connectivity
        case email
        case server
        case unknown
    }
    
    public init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    public func send(newAccountPayload: NewAccountPayload, completion: @escaping (Result<Void, Swift.Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(newAccountPayload)
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(_, response):
                completion(NewAccountServiceResultMapper.result(for: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
