//
//  RegisterViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import Foundation
import BeChattedUserInputValidation

public final class RegisterViewModel: ObservableObject {
    private let emailValidator: EmailValidatorProtocol
    private let passwordValidator: PasswordValidatorProtocol
    
    @Published public var name: String = ""
    @Published public var email: String = ""
    @Published public var password: String = ""
    public var isUserInputValid: Bool {
        !name.isEmpty && emailValidator.isValid(email: email) && passwordValidator.isValid(password: password)
    }
    
    public init(emailValidator: EmailValidatorProtocol, passwordValidator: PasswordValidatorProtocol) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
    }
}
