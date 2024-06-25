//
//  EmailValidatorStub.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 22.02.2024.
//

import Foundation
import BeChatted

struct EmailValidatorStub: EmailValidatorProtocol {
  let isValidStubbed: Bool
  
  func isValid(email: String) -> Bool {
    isValidStubbed
  }
}
