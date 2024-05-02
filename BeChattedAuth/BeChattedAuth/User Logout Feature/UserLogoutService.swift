//
//  UserLogoutService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 07.04.2023.
//

import Foundation

final class UserLogoutService: UserLogoutServiceProtocol {
    
    private let url: URL
    private let client: HTTPClientProtocol
    
    init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    func logout(completion: @escaping (Result<Void, UserLogoutServiceError>) -> Void) {
        let request = URLRequest(url: url)
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success:
                completion(.success(()))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
