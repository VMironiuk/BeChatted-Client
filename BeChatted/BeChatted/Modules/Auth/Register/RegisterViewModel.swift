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
        let authService = self.authService
        let email = self.email
        let name = self.name
        let password = self.password
        authService.createAccount(NewAccountPayload(email: email, password: password)) { result in
            switch result {
            case .success:
                print("CREATE_ACCOUNT: SUCCESS")
                authService.login(UserLoginPayload(email: email, password: password)) { result in
                    switch result {
                    case .success(let userLoginInfo):
                        print("LOGIN: SUCCESS: \(userLoginInfo)")
                        authService.addUser(
                            NewUserPayload(
                                name: name,
                                email: email,
                                avatarName: "",
                                avatarColor: "")) { result in
                                    switch result {
                                    case .success:
                                        print("ADD_USER: SUCCESS")
                                    case .failure(let error):
                                        completion(.failure(error))
                                    }
                                }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
