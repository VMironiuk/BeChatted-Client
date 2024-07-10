//
//  UserServiceStub.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 09.07.2024.
//

import Foundation
import BeChatted

final class UserServiceStub: UserServiceProtocol {
  private var completions = [(Result<UserInfo, UserServiceError>) -> Void]()
  
  var userByEmailCallCount: Int {
    completions.count
  }
  
  func user(
    by email: String, 
    authToken: String,
    completion: @escaping (Result<UserInfo, UserServiceError>) -> Void
  ) {
    completions.append(completion)
  }
  
  func complete(with error: UserServiceError, at index: Int = 0) {
    completions[index](.failure(error))
  }
  
  func complete(with userInfo: UserInfo, at index: Int = 0) {
    completions[index](.success(userInfo))
  }
}
