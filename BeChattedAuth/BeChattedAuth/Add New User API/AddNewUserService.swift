//
//  AddNewUserService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.04.2023.
//

import Foundation

final class AddNewUserService: AddNewUserServiceProtocol {
    private let url: URL
    private let client: HTTPClientProtocol
    
    enum AddNewUserError: Swift.Error {
        case connectivity
        case server
        case unknown
        case invalidData
    }
    
    typealias Error = AddNewUserError
    
    init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    func send(
        newUserPayload: NewUserPayload,
        authToken: String,
        completion: @escaping (Result<NewUserInfo, Swift.Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(newUserPayload)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(AddNewUserServiceResultMapper.result(for: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
