//
//  UserInputValidatorProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import Foundation

public protocol EmailValidatorProtocol {
  func isValid(email: String) -> Bool
}

public protocol PasswordValidatorProtocol {
  func isValid(password: String) -> Bool
}
