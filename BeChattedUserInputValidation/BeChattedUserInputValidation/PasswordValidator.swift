//
//  PasswordValidator.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.06.2023.
//

import Foundation

public protocol PasswordValidatorProtocol {
    func isValid(password: String) -> Bool
}

public struct PasswordValidator: PasswordValidatorProtocol {
    public init() {}
    
    public func isValid(password: String) -> Bool {
        !password.contains(" ") && password.count >= 8
    }
}
