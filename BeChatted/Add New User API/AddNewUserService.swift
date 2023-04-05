//
//  AddNewUserService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.04.2023.
//

import Foundation

public final class AddNewUserService: AddNewUserServiceProtocol {
    private let url: URL
    private let client: HTTPClientProtocol
    
    public enum AddNewUserError: Swift.Error {
        case connectivity
        case server
        case unknown
        case invalidData
    }
    
    public typealias Error = AddNewUserError
    
    public init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    public func send(newUserPayload: NewUserPayload, completion: @escaping (Result<NewUserInfo, Swift.Error>) -> Void) {
        let request = URLRequest(url: url)
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                if response?.statusCode == 200 {
                    if let data = data, let newUser = try? JSONDecoder().decode(NewUserInfo.self, from: data) {
                        completion(.success(newUser))
                    } else {
                        completion(.failure(AddNewUserError.invalidData))
                    }
                } else if response?.statusCode == 500 {
                    completion(.failure(AddNewUserError.server))
                } else {
                    completion(.failure(AddNewUserError.unknown))
                }
                break
            case .failure:
                completion(.failure(AddNewUserError.connectivity))
            }
        }
    }
}
