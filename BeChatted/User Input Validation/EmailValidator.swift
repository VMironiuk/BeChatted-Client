//
//  EmailValidator.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.05.2023.
//

import Foundation

public struct EmailValidator {
    public init() {}
    
    public func isValid(_ email: String) -> Bool {
        let emailRegEx = "^(?!\\.)(?!.*\\.\\.)(?!_)(?!.*_{2})[A-Z0-9a-z%+\\-]{1,64}(\\.[A-Z0-9a-z%+\\-]+)*@(?!-)(?!.*--)[A-Za-z0-9.-]{1,255}\\.[A-Za-z]{2,63}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}
