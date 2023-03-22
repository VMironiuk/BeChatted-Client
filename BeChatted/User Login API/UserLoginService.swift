//
//  UserLoginService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 22.03.2023.
//

import Foundation

public final class UserLoginService: UserLoginServiceProtocol {
    private let url: URL
    private let client: HTTPClientProtocol
    
    public enum Error: Swift.Error {
        case connectivity
        case credentials
        case server
        case invalidData
        case unknown
    }
    
    public init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    public func send(userLoginPayload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, Swift.Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(userLoginPayload)
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                if let response = response {
                    if response.statusCode == 200 {
                        if let data = data, let userInfo = try? JSONDecoder().decode(UserLoginInfo.self, from: data) {
                            completion(.success(userInfo))
                        } else {
                            completion(.failure(Error.invalidData))
                        }
                    } else if response.statusCode == 401 {
                        completion(.failure(Error.credentials))
                    } else if (500...599).contains(response.statusCode) {
                        completion(.failure(Error.server))
                    } else {
                        completion(.failure(Error.unknown))
                    }
                }
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
