//
//  PasswordValidatorStub.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 22.02.2024.
//

import Foundation
import BeChatted

struct PasswordValidatorStub: PasswordValidatorProtocol {
  let isValidStubbed: Bool
  
  func isValid(password: String) -> Bool {
    isValidStubbed
  }
}
