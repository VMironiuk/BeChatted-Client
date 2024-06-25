//
//  LogoutResultMapper.swift
//  BeChattedAuth
//
//  Created by Volodymyr Myroniuk on 02.12.2023.
//

import Foundation

enum LogoutResultMapper {
  static func result(for result: Result<Void, UserLogoutServiceError>) -> Result<Void, AuthServiceError> {
    switch result {
    case .success:
      return .success(())
    case .failure(let error):
      return .failure(map(error: error))
    }
  }
  
  static private func map(error: UserLogoutServiceError) -> AuthServiceError {
    switch error {
    case .connectivity:
      return .connectivity
    }
  }
}
