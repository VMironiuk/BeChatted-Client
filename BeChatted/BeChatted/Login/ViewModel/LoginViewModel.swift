//
//  LoginViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import Foundation

public struct LoginPayload: Encodable, Equatable {
    private let email: String
    private let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct LoginInfo: Decodable, Equatable {
    public let user: String
    public let token: String
}

public struct CreateAccountPayload: Encodable, Equatable {
    private let email: String
    private let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct AddUserPayload: Encodable, Equatable {
    private let name: String
    private let email: String
    private let avatarName: String
    private let avatarColor: String
    
    public init(name: String, email: String, avatarName: String, avatarColor: String) {
        self.name = name
        self.email = email
        self.avatarName = avatarName
        self.avatarColor = avatarColor
    }
}

public struct AddedUserInfo: Decodable, Equatable {
    public let name: String
    public let email: String
    public let avatarName: String
    public let avatarColor: String
}

@Observable public final class LoginViewModel {
    private let emailValidator: EmailValidatorProtocol
    private let passwordValidator: PasswordValidatorProtocol
    private let authService: AuthServiceProtocol
    
    private(set) var authError: AuthError?
    
    public var email: String = ""
    public var password: String = ""
    public var isUserInputValid: Bool {
        emailValidator.isValid(email: email) && passwordValidator.isValid(password: password)
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
    
    public func login(completion: @escaping (Result<Void, AuthError>) -> Void) {
        authService.login(LoginPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                self?.authError = error
                completion(.failure(error))
            }
        }
    }
}
