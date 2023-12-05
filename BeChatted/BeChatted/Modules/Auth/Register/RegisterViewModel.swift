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
    public typealias RegisterCompletion = (Result<Void, Error>) -> Void
    
    public struct Error: Swift.Error, Equatable {
        let title: String
        let description: String
        
        public init(title: String, description: String) {
            self.title = title
            self.description = description
        }
    }
    
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
    
    public func register(completion: @escaping RegisterCompletion) {
        createAccount(completion: completion)
    }
    
    private func createAccount(completion: @escaping RegisterCompletion) {
        authService.createAccount(NewAccountPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case .success:
                self?.login(completion: completion)
            case .failure(let error):
                completion(.failure(RegisterErrorMapper.error(for: error)))
            }
        }
    }
        
    private func login(completion: @escaping RegisterCompletion) {
        authService.login(UserLoginPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case let .success(loginInfo):
                self?.addUser(with: loginInfo.token, completion: completion)
            case .failure(let error):
                completion(.failure(RegisterErrorMapper.error(for: error)))
            }
        }
    }
    
    private func addUser(with authToken: String, completion: @escaping RegisterCompletion) {
        let newUserPayload = NewUserPayload(name: name, email: email, avatarName: "", avatarColor: "")
        authService.addUser(newUserPayload, authToken: authToken) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(RegisterErrorMapper.error(for: error)))
            }
        }
    }
}
