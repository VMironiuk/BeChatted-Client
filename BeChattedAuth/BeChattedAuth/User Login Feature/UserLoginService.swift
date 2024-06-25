//
//  UserLoginService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 22.03.2023.
//

import Foundation

struct UserLoginService: UserLoginServiceProtocol {
  private let url: URL
  private let client: HTTPClientProtocol
  
  init(url: URL, client: HTTPClientProtocol) {
    self.url = url
    self.client = client
  }
  
  func send(
    userLoginPayload: UserLoginPayload,
    completion: @escaping (Result<UserLoginInfo, UserLoginServiceError>) -> Void
  ) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONEncoder().encode(userLoginPayload)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    client.perform(request: request) { result in
      switch result {
      case let .success((data, response)):
        completion(UserLoginServiceResultMapper.result(for: data, response: response))
      case .failure:
        completion(.failure(.connectivity))
      }
    }
  }
}
