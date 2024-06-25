//
//  ChannelCreatingResultMapper.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 16.05.2024.
//

import Foundation

enum ChannelCreatingResultMapper {
  static func result(for response: HTTPURLResponse?) -> Result<Void, ChannelCreatingError> {
    guard let response = response else { return .failure(.unknown) }
    
    switch response.statusCode {
    case 200:
      return .success(())
    case 500:
      return .failure(.server)
    default:
      return .failure(.connectivity)
    }
  }
}
