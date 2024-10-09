//
//  PasswordValidator+PasswordValidatorProtocol.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 27.02.2024.
//

import Foundation
import BeChatted
import BeChattedUserInputValidation

struct PasswordValidatorWrapper: PasswordValidatorProtocol {
  let passwordValidator: PasswordValidator
  
  func isValid(password: String) -> Bool {
    passwordValidator.isValid(password: password)
  }
}
