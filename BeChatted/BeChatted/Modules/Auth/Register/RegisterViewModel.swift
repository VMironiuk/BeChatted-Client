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
    
    public func register(completion: @escaping (Result<Void, Error>) -> Void) {
        createAccount(completion: completion)
    }
    
    private func createAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        authService.createAccount(NewAccountPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case .success:
                self?.login(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
        
    private func login(completion: @escaping (Result<Void, Error>) -> Void) {
        authService.login(UserLoginPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case .success:
                self?.addUser(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func addUser(completion: @escaping (Result<Void, Error>) -> Void) {
        authService.addUser(NewUserPayload(name: name, email: email, avatarName: "", avatarColor: "")) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
