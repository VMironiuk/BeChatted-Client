//
//  RegisterViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import Foundation

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
    
    public init(
        emailValidator: EmailValidatorProtocol,
        passwordValidator: PasswordValidatorProtocol,
        authService: AuthServiceProtocol
    ) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        self.authService = authService
    }
    
    public func register(completion: @escaping RegisterCompletion) {
        createAccount(completion: completion)
    }
    
    private func createAccount(completion: @escaping RegisterCompletion) {
        authService.createAccount(CreateAccountPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case .success:
                self?.login(completion: completion)
            case .failure(let error):
                self?.authError = error
                completion(.failure(error))
            }
        }
    }
        
    private func login(completion: @escaping RegisterCompletion) {
        authService.login(LoginPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case let .success(loginInfo):
                self?.addUser(with: loginInfo.token, completion: completion)
            case .failure(let error):
                self?.authError = error
                completion(.failure(error))
            }
        }
    }
    
    private func addUser(with authToken: String, completion: @escaping RegisterCompletion) {
        let newUserPayload = AddUserPayload(name: name, email: email, avatarName: "", avatarColor: "")
        authService.addUser(newUserPayload, authToken: authToken) { [weak self] result in
            switch result {
            case .success:
                completion(.success(()))
                self?.name = ""
                self?.email = ""
                self?.password = ""
            case .failure(let error):
                self?.authError = error
                completion(.failure(error))
            }
        }
    }
}
