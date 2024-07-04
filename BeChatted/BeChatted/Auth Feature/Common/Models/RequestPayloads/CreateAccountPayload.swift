//
//  CreateAccountPayload.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import Foundation

public struct CreateAccountPayload: Encodable, Equatable {
  public let email: String
  public let password: String
  
  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }
}
