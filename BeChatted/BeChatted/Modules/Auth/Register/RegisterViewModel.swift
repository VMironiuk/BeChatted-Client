//
//  RegisterViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import Foundation
import BeChattedAuth
import BeChattedUserInputValidation

public final class RegisterViewModel: ObservableObject {
    private let emailValidator: EmailValidatorProtocol
    private let passwordValidator: PasswordValidatorProtocol
    private let authService: AuthServiceProtocol
    
    @Published public var name: String = ""
    @Published public var email: String = ""
    @Published public var password: String = ""
    public var isUserInputValid: Bool {
        !name.isEmpty && emailValidator.isValid(email: email) && passwordValidator.isValid(password: password)
    }
    
    public init(
        emailValidator: EmailValidatorProtocol,
        passwordValidator: PasswordValidatorProtocol,
        authService: AuthServiceProtocol
    ) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        self.authService = authService
    }
    
    public func register() {
        authService.createAccount(NewAccountPayload(email: email, password: password)) { result in
            switch result {
            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
        }
    }
}
