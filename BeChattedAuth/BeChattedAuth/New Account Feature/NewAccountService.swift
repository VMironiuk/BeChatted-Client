//
//  NewAccountService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 24.02.2023.
//

import Foundation

struct NewAccountService: NewAccountServiceProtocol {
  private let url: URL
  private let client: HTTPClientProtocol
  
  init(url: URL, client: HTTPClientProtocol) {
    self.url = url
    self.client = client
  }
  
  func send(newAccountPayload: NewAccountPayload, completion: @escaping (Result<Void, NewAccountServiceError>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = try? JSONEncoder().encode(newAccountPayload)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    client.perform(request: request) { result in
      switch result {
      case let .success((_, response)):
        completion(NewAccountServiceResultMapper.result(for: response))
      case .failure:
        completion(.failure(.connectivity))
      }
    }
  }
}
