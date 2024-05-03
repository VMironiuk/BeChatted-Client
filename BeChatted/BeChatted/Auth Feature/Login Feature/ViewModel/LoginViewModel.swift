//
//  LoginViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import Foundation

@Observable public final class LoginViewModel {
    private let emailValidator: EmailValidatorProtocol
    private let passwordValidator: PasswordValidatorProtocol
    private let authService: AuthServiceProtocol
    
    private var authError: AuthError?
    
    public var email: String = ""
    public var password: String = ""
    public var isUserInputValid: Bool {
        emailValidator.isValid(email: email) && passwordValidator.isValid(password: password)
    }
    public var errorTitle: String {
        authError?.title ?? "Login Failed"
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
    
    public func login(completion: @escaping (Result<LoginInfo, AuthError>) -> Void) {
        authService.login(LoginPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case .success(let loginInfo):
                completion(.success(loginInfo))
            case .failure(let error):
                self?.authError = error
                completion(.failure(error))
            }
        }
    }
}
