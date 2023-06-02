//
//  PasswordValidator.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.06.2023.
//

import Foundation

public struct PasswordValidator {
    public init() {}
    
    public func isValid(_ password: String) -> Bool {
        !password.contains(" ") && password.count >= 8
    }
}
