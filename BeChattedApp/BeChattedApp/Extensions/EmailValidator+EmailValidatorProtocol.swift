//
//  EmailValidator+EmailValidatorProtocol.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 27.02.2024.
//

import Foundation
import BeChatted
import BeChattedUserInputValidation

struct EmailValidatorWrapper: EmailValidatorProtocol {
  let emailValidator: EmailValidator
  
  func isValid(email: String) -> Bool {
    emailValidator.isValid(email: email)
  }
}
