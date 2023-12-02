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
                print("MYLOG: CREATE ACCOUNT: SUCCESS!")
                self?.login(completion: completion)
            case .failure(let error):
                print("MYLOG: CREATE ACCOUNT: FAILED: \(error) (\(error.localizedDescription))")
                completion(.failure(error))
            }
        }
    }
        
    private func login(completion: @escaping RegisterCompletion) {
        authService.login(UserLoginPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case let .success(loginInfo):
                print("MYLOG: LOGIN: SUCCESS!")
                self?.addUser(with: loginInfo.token, completion: completion)
            case .failure(let error):
                print("MYLOG: LOGIN: FAILED: \(error) (\(error.localizedDescription))")
                completion(.failure(error))
            }
        }
    }
    
    private func addUser(with authToken: String, completion: @escaping RegisterCompletion) {
        let newUserPayload = NewUserPayload(name: name, email: email, avatarName: "", avatarColor: "")
        authService.addUser(newUserPayload, authToken: authToken) { result in
            switch result {
            case .success:
                print("MYLOG: ADD USER: SUCCESS!")
                completion(.success(()))
            case .failure(let error):
                print("MYLOG: ADD USER: FAILED: \(error) (\(error.localizedDescription))")
                completion(.failure(error))
            }
        }
    }
}
