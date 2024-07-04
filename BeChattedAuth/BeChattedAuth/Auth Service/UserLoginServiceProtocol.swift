//
//  UserLoginServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.03.2023.
//

import Foundation

public struct UserLoginPayload: Encodable, Equatable {
  private let email: String
  private let password: String
  
  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }
}

public struct UserLoginInfo: Decodable, Equatable {
  public let user: String
  public let token: String
}

enum UserLoginServiceError: Error {
  case connectivity
  case credentials
  case server
  case invalidData
  case unknown
}

protocol UserLoginServiceProtocol {
  func send(userLoginPayload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, UserLoginServiceError>) -> Void)
}
