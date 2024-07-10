//
//  UserServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 09.07.2024.
//

import Foundation

public enum UserServiceError: Error {
  case connectivity
  case invalidData
}

public protocol UserServiceProtocol {
  func user(
    by email: String,
    authToken: String,
    completion: @escaping (Result<UserInfo, UserServiceError>) -> Void
  )
}
