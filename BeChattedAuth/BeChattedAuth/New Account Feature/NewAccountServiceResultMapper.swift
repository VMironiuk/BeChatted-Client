//
//  NewAccountServiceResultMapper.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 25.02.2023.
//

import Foundation


enum NewAccountServiceResultMapper {
  static func result(for response: HTTPURLResponse?) -> Result<Void, NewAccountServiceError> {
    guard let response = response else { return .failure(.unknown) }
    
    switch response.statusCode {
    case 200:
      return .success(())
    case 300:
      return .failure(.email)
    case 500...599:
      return .failure(.server)
    default:
      return .failure(.unknown)
    }
  }
}
