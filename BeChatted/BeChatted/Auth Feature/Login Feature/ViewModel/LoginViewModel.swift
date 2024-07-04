//
//  LoginViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import Foundation

public final class LoginViewModel: ObservableObject {
  public enum State: Equatable {
    case idle
    case inProgress
    case success
    case failure(AuthError)
  }
  
  private let emailValidator: EmailValidatorProtocol
  private let passwordValidator: PasswordValidatorProtocol
  private let authService: AuthServiceProtocol
  
  private let onLoginSuccessAction: (String) -> Void
  
  @Published public var state = State.idle
  @Published public var email: String = ""
  @Published public var password: String = ""
  
  public var isUserInputValid: Bool {
    emailValidator.isValid(email: email) && passwordValidator.isValid(password: password)
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
    authService: AuthServiceProtocol,
    onLoginSuccessAction: @escaping (String) -> Void
  ) {
    self.emailValidator = emailValidator
    self.passwordValidator = passwordValidator
    self.authService = authService
    self.onLoginSuccessAction = onLoginSuccessAction
  }
  
  public func login() {
    state = .inProgress
    authService.login(LoginPayload(email: email, password: password)) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let loginInfo):
          self?.state = .success
          self?.onLoginSuccessAction(loginInfo.token)
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
