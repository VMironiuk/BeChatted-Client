//
//  LoginView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.10.2023.
//

import SwiftUI
import BeChatted

struct LoginView: View {
  @ObservedObject private var viewModel: LoginViewModel
  private let footerView: AuthFooterView
  
  private var authButtonState: PrimaryButtonStyle.State {
    switch viewModel.state {
    case .idle, .success: .normal
    case .loggingIn, .fetchingUser: .loading
    case .failure: .failed
    }
  }
  
  private var isLoginButtonDisabled: Bool {
    switch viewModel.state {
    case .failure, .loggingIn, .fetchingUser: true
    default: !viewModel.isUserInputValid
    }
  }
  
  var onTapped: (() -> Void)?
  var onLoginButtonTapped: (() -> Void)?
  
  init(viewModel: LoginViewModel, footerView: AuthFooterView) {
    self.viewModel = viewModel
    self.footerView = footerView
    
  }
  
  var body: some View {
    ZStack {
      VStack {
        LoginHeaderView()
        LoginInputView(email: $viewModel.email, password: $viewModel.password)
        VStack {
          Spacer()
          button
          footerView
        }
        .contentShape(Rectangle())
        .onTapGesture {
          onTapped?()
        }
      }
    }
  }
}

// MARK: - Login Button

private extension LoginView {
  private var buttonTitle: String {
    switch authButtonState {
    case .normal:
      return "Login"
    case .loading:
      return "Logging In..."
    case .failed:
      return viewModel.errorTitle
    }
  }
  
  private var button: some View {
    Button(buttonTitle) {
      onLoginButtonTapped?()
      viewModel.login()
    }
    .buttonStyle(PrimaryButtonStyle(state: authButtonState, isEnabled: viewModel.isUserInputValid))
    .disabled(isLoginButtonDisabled)
    .padding(.horizontal, 20)
    .padding(.bottom, 32)
    .animation(.easeIn(duration: 0.2), value: authButtonState)
  }
}

#Preview {
  LoginView(
    viewModel: LoginViewModel(
      emailValidator: EmailValidator(),
      passwordValidator: PasswordValidator(),
      authService: AuthService(),
      userService: UserService(),
      onLoginSuccessAction: { _, _ in }),
    footerView: AuthFooterView(text: "Don't have an account?", buttonText: "Register") {})
}

private struct EmailValidator: EmailValidatorProtocol {
  func isValid(email: String) -> Bool { false }
}

private struct PasswordValidator: PasswordValidatorProtocol {
  func isValid(password: String) -> Bool { false }
}

private struct AuthService: AuthServiceProtocol {
  func login(_ payload: LoginPayload, completion: @escaping (Result<LoginInfo, AuthError>) -> Void) {
  }
  
  func createAccount(_ payload: CreateAccountPayload, completion: @escaping (Result<Void, AuthError>) -> Void) {
  }
  
  func addUser(_ payload: AddUserPayload, authToken: String, completion: @escaping (Result<AddedUserInfo, AuthError>) -> Void) {
  }
  
  func logout(authToken: String, completion: @escaping (Result<Void, any Error>) -> Void) {
  }
}

private struct UserService: UserServiceProtocol {
  func user(
    by email: String,
    authToken: String,
    completion: @escaping (Result<BeChatted.UserInfo, BeChatted.UserServiceError>) -> Void
  ) {
  }
}
