//
//  UserProfileInfo.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.07.2024.
//

import Foundation

public struct UserProfileInfo {
  public let name: String
  public let email: String
  
  public init(name: String, email: String) {
    self.name = name
    self.email = email
  }
}
