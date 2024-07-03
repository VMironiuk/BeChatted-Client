//
//  UserLogoutService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 07.04.2023.
//

import Foundation

struct UserLogoutService: UserLogoutServiceProtocol {
  
  private let url: URL
  private let client: HTTPClientProtocol
  
  init(url: URL, client: HTTPClientProtocol) {
    self.url = url
    self.client = client
  }
  
  func logout(authToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
    var request = URLRequest(url: url)
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    
    client.perform(request: request) { result in
      switch result {
      case .success:
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
