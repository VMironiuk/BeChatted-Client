//
//  LoginResultMapper.swift
//  BeChattedAuth
//
//  Created by Volodymyr Myroniuk on 02.12.2023.
//

import Foundation

enum LoginResultMapper {
  static func result(for result: Result<UserLoginInfo, UserLoginServiceError>) -> Result<UserLoginInfo, AuthServiceError> {
    switch result {
    case .success(let userLoginInfo):
      return .success(userLoginInfo)
    case .failure(let error):
      return .failure(map(error: error))
    }
  }
  
  static private func map(error: UserLoginServiceError) -> AuthServiceError {
    switch error {
    case .server:
      return .server
    case .connectivity:
      return .connectivity
    case .credentials:
      return .credentials
    case .invalidData, .unknown:
      return .unknown
    }
  }
}
