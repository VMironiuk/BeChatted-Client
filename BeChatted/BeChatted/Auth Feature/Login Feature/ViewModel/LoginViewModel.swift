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
    case loggingIn
    case fetchingUser
    case success
    case failure(AuthError)
  }
  
  private let emailValidator: EmailValidatorProtocol
  private let passwordValidator: PasswordValidatorProtocol
  private let authService: AuthServiceProtocol
  private let userService: UserServiceProtocol
  
  private let onLoginSuccessAction: (String, UserInfo) -> Void
  
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
    userService: UserServiceProtocol,
    onLoginSuccessAction: @escaping (String, UserInfo) -> Void
  ) {
    self.emailValidator = emailValidator
    self.passwordValidator = passwordValidator
    self.authService = authService
    self.userService = userService
    self.onLoginSuccessAction = onLoginSuccessAction
  }
  
  public func login() {
    state = .loggingIn
    authService.login(LoginPayload(email: email, password: password)) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let loginInfo):
          self?.state = .fetchingUser
          self?.fetchUserInfo(authToken: loginInfo.token)
        case .failure(let error):
          self?.state = .failure(error)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self?.state = .idle
          }
        }
      }
    }
  }
  
  private func fetchUserInfo(authToken: String) {
    userService.user(by: email, authToken: authToken) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let userInfo):
          self?.state = .success
          self?.onLoginSuccessAction(authToken, userInfo)
        case .failure:
          self?.state = .failure(.fetchUser)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self?.state = .idle
          }
        }
      }
    }
  }
}
