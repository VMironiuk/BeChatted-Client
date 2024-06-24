//
//  RegisterViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import Foundation

public final class RegisterViewModel: ObservableObject {
    public enum State: Equatable {
        case idle
        case inProgress
        case success
        case failure(AuthError)
    }
    
    private let emailValidator: EmailValidatorProtocol
    private let passwordValidator: PasswordValidatorProtocol
    private let authService: AuthServiceProtocol
    
    @Published public var state = State.idle
    @Published public var name: String = ""
    @Published public var email: String = ""
    @Published public var password: String = ""
    
    public var isUserInputValid: Bool {
        !name.isEmpty && emailValidator.isValid(email: email) && passwordValidator.isValid(password: password)
    }
    
    public var errorTitle: String {
        if case let .failure(authError) = state {
            return authError.title
        }
        return ""
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
        state = .inProgress
        createAccount()
    }
    
    private func createAccount() {
        authService.createAccount(CreateAccountPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case .success:
                self?.login()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.state = .failure(error)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.state = .idle
                    }
                }
            }
        }
    }

    private func login() {
        authService.login(LoginPayload(email: email, password: password)) { [weak self] result in
            switch result {
            case let .success(loginInfo):
                self?.addUser(with: loginInfo.token)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.state = .failure(error)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.state = .idle
                    }
                }
            }
        }
    }
    
    private func addUser(with authToken: String) {
        let newUserPayload = AddUserPayload(name: name, email: email, avatarName: "", avatarColor: "")
        authService.addUser(newUserPayload, authToken: authToken) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.state = .success
                case .failure(let error):
                    self?.state = .failure(error)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.state = .idle
                    }
                }
            }
        }
    }
}
