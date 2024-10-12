//
//  NewAccountServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 17.02.2023.
//

import Foundation

public struct NewAccountPayload: Codable, Equatable {
  private enum CodingKeys: String, CodingKey {
    case email
    case password
  }

  private let email: String
  private let password: String
  
  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let email = try container.decode(String.self, forKey: .email)
    let password = try container.decode(String.self, forKey: .password)
    
    self.init(email: email, password: password)
  }
}

enum NewAccountServiceError: Error {
  case connectivity
  case email
  case server
  case unknown
}

protocol NewAccountServiceProtocol {
  func send(newAccountPayload: NewAccountPayload, completion: @escaping (Result<Void, NewAccountServiceError>) -> Void)
}
