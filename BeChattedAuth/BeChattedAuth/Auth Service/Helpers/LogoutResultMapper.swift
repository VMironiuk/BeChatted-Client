//
//  LogoutResultMapper.swift
//  BeChattedAuth
//
//  Created by Volodymyr Myroniuk on 02.12.2023.
//

import Foundation

enum LogoutResultMapper {
  static func result(for result: Result<Void, Error>) -> Result<Void, Error> {
    switch result {
    case .success:
      return .success(())
    case .failure(let error):
      return .failure(error)
    }
  }
}
