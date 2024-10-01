//
//  MessagingServiceResultMapper.swift
//  BeChattedMessaging
//
//  Created by Volodymyr Myroniuk on 03.09.2024.
//

import Foundation

enum MessagingServiceResultMapper {
  static func result(
    for data: Data?,
    response: HTTPURLResponse?
  ) -> Result<[MessagingService.MessageInfo], MessagingService.LoadMessagesError> {
    guard response?.statusCode != 500 else {
      return .failure(.server)
    }
    
    guard response?.statusCode == 200 else {
      return .failure(.invalidResponse)
    }
    
    guard let data, 
          let messages = try? JSONDecoder().decode([MessagingService.MessageInfo].self, from: data) else {
      return .failure(.invalidData)
    }
    
    return .success(messages)
  }
}
