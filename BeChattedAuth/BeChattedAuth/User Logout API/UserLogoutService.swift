//
//  UserLogoutService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 07.04.2023.
//

import Foundation

public final class UserLogoutService: UserLogoutServiceProtocol {
    
    private let url: URL
    private let client: HTTPClientProtocol
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    public func logout(completion: @escaping (Result<Void, Swift.Error>) -> Void) {
        let request = URLRequest(url: url)
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success:
                completion(.success(()))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
