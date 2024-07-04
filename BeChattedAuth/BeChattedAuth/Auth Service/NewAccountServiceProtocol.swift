//
//  NewAccountServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 17.02.2023.
//

import Foundation

public struct NewAccountPayload: Encodable, Equatable {
  private let email: String
  private let password: String
  
  public init(email: String, password: String) {
    self.email = email
    self.password = password
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
