//
//  UserLoginService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 22.03.2023.
//

import Foundation

public protocol HTTPClient {
    func perform(request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}

public final class UserLoginService {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case credentials
        case server
        case invalidData
        case unknown
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func send(userLoginPayload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(userLoginPayload)
        
        client.perform(request: request) { [weak self] data, response, error in
            guard self != nil else { return }
            if error != nil {
                completion(.failure(.connectivity))
            } else if let response = response {
                if response.statusCode == 200 {
                    if let data = data, let userInfo = try? JSONDecoder().decode(UserLoginInfo.self, from: data) {
                        completion(.success(userInfo))
                    } else {
                        completion(.failure(.invalidData))
                    }
                } else if response.statusCode == 401 {
                    completion(.failure(.credentials))
                } else if (500...599).contains(response.statusCode) {
                    completion(.failure(.server))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }
    }
}
