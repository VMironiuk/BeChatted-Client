//
//  EmailValidator.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.05.2023.
//

import Foundation

public struct EmailValidator {
    public init() {}
    
    public func isValid(email: String) -> Bool {
        let emailRegEx = [
            "^(?!\\.)",                  // Local part should not start with a period
            "(?!.*\\.\\.)",              // Local part should not contain consecutive periods
            "(?!_)",                     // Local part should not start with an underscore
            "(?!.*_{2})",                // Local part should not contain consecutive underscores
            "[A-Z0-9a-z%+\\-]{1,64}",    // Valid characters for the local part (1-64 characters)
            "(\\.[A-Z0-9a-z%+\\-]+)*",   // Allow multiple segments separated by periods
            "@",                         // Mandatory at symbol
            "(?!-)",                     // Domain part should not start with a hyphen
            "(?!.*--)",                  // Domain part should not contain consecutive hyphens
            "[A-Za-z0-9.-]{1,255}",      // Valid characters for the domain part (1-255 characters)
            "\\.[A-Za-z]{2,63}",         // Top-level domain (2-63 characters)
            "$",
        ].joined()
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}
