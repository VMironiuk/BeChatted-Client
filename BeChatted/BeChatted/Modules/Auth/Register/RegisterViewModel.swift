//
//  RegisterViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import Foundation
import BeChattedAuth
import BeChattedUserInputValidation

@Observable public final class RegisterViewModel {
    public typealias RegisterCompletion = (Result<Void, AuthError>) -> Void
    
    private let emailValidator: EmailValidatorProtocol
    private let passwordValidator: PasswordValidatorProtocol
    private let authService: AuthServiceProtocol
    
    private(set) var authError: AuthError?
    
    public var name: String = ""
    public var email: String = ""
    public var password: String = ""
    public var isUserInputValid: Bool {
        !name.isEmpty && emailValidator.isValid(email: email) && passwordValidator.isValid(password: password)
    }
    public let successMessageTitle: String
    public let successMessageDescription: String
    
    public init(
        emailValidator: EmailValidatorProtocol,
        passwordValidator: PasswordValidatorProtocol,
        authService: AuthServiceProtocol,
        successMessage: MessageProtocol
    ) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        self.authService = authService
        self.successMessageTitle = successMessage.title
        self.successMessageDescription = successMessage.description
    }
    
    public func register(completion: @escaping RegisterCompletion) {
        createAccount(completion: completion)
    }
    
    private func createAccount(completion: @escaping RegisterCompletion) {
        authService.createAccount(NewAccountPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case .success:
                self?.login(completion: completion)
            case .failure(let error):
                self?.authError = AuthError(authServiceError: error)
                completion(.failure(AuthError(authServiceError: error)))
            }
        }
    }
        
    private func login(completion: @escaping RegisterCompletion) {
        authService.login(UserLoginPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case let .success(loginInfo):
                self?.addUser(with: loginInfo.token, completion: completion)
            case .failure(let error):
                self?.authError = AuthError(authServiceError: error)
                completion(.failure(AuthError(authServiceError: error)))
            }
        }
    }
    
    private func addUser(with authToken: String, completion: @escaping RegisterCompletion) {
        let newUserPayload = NewUserPayload(name: name, email: email, avatarName: "", avatarColor: "")
        authService.addUser(newUserPayload, authToken: authToken) { [weak self] result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                self?.authError = AuthError(authServiceError: error)
                completion(.failure(AuthError(authServiceError: error)))
            }
        }
    }
}
