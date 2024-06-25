//
//  UserLogoutServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 07.04.2023.
//

import Foundation

enum UserLogoutServiceError: Error {
  case connectivity
}

protocol UserLogoutServiceProtocol {
  func logout(completion: @escaping (Result<Void, UserLogoutServiceError>) -> Void)
}
