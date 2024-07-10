//
//  UserInfo.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 09.07.2024.
//

import Foundation

public struct UserInfo {
  public let id: String
  public let name: String
  public let email: String
  
  public init(id: String, name: String, email: String) {
    self.id = id
    self.name = name
    self.email = email
  }
}
