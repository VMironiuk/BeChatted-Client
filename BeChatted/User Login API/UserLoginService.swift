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
    
    public func send(
        userLoginPayload: UserLoginPayload,
        completion: @escaping (Result<UserLoginInfo, Swift.Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(userLoginPayload)
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(UserLoginServiceResultMapper.result(for: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
