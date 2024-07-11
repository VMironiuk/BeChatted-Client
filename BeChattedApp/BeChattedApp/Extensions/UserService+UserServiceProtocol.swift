//
//  UserService+UserServiceProtocol.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 10.07.2024.
//

import BeChatted
import BeChattedUser

extension UserService: UserServiceProtocol {
  public func user(
    by email: String,
    authToken: String,
    completion: @escaping (Result<UserInfo, BeChatted.UserServiceError>) -> Void
  ) {
    user(by: email, authToken: authToken) { result in
      switch result {
      case .success(let userData):
        completion(.success(UserInfo(userData: userData)))
      case .failure(let error):
        completion(.failure(error.mapped))
      }
    }
  }
}

private extension UserInfo {
  init(userData: UserData) {
    self.init(
      id: userData.id,
      name: userData.name,
      email: userData.email
    )
  }
}

private extension BeChattedUser.UserServiceError {
  var mapped: BeChatted.UserServiceError {
    switch self {
    case .connectivity: .connectivity
    case .invalidData: .invalidData
    @unknown default:
      fatalError("Unknown error")
    }
  }
}
