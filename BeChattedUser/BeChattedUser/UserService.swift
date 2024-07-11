//
//  UserService.swift
//  BeChattedUser
//
//  Created by Volodymyr Myroniuk on 10.07.2024.
//

import Foundation

public protocol HTTPClientProtocol {
  func perform(
    request: URLRequest,
    completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void
  )
}

public struct UserData: Codable {
  public let id: String
  public let name: String
  public let email: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case name
    case email
  }
  
  public init(id: String, name: String, email: String) {
    self.id = id
    self.name = name
    self.email = email
  }
}

public enum UserServiceError: Error {
  case connectivity
  case invalidData
}

public struct UserService {
  private let url: URL
  private let client: HTTPClientProtocol
  
  private var urlString: String {
    url.absoluteString
  }
  
  public init(url: URL, client: HTTPClientProtocol) {
    self.url = url
    self.client = client
  }
  
  public func user(
    by email: String,
    authToken: String,
    completion: @escaping (Result<UserData, UserServiceError>) -> Void
  ) {
    guard let url = URL(string: "\(urlString)/\(email)") else {
      completion(.failure(.invalidData))
      return
    }
    
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    
    client.perform(request: request) { result in
      switch result {
      case let .success((data, response)):
        guard response?.statusCode == 200 else {
          completion(.failure(.connectivity))
          return
        }
        guard let data = data, let user = try? JSONDecoder().decode(UserData.self, from: data) else {
          completion(.failure(.invalidData))
          return
        }
        completion(.success(user))
        
      case .failure:
        completion(.failure(.connectivity))
      }
    }
  }
}
