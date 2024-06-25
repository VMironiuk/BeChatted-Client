//
//  RegisterView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 28.10.2023.
//

import SwiftUI
import BeChatted

struct RegisterView: View {
  @ObservedObject private var viewModel: RegisterViewModel
  private let headerView: RegisterHeaderView
  private let footerView: AuthFooterView
  
  @Environment(\.isKeyboardShown) var isKeyboardShown
  
  private var authButtonState: PrimaryButtonStyle.State {
    switch viewModel.state {
    case .idle, .success: .normal
    case .inProgress: .loading
    case .failure: .failed
    }
  }
  
  private var isRegisterButtonDisabled: Bool {
    if case .failure = viewModel.state { return true }
    if case .inProgress = viewModel.state { return true }
    return !viewModel.isUserInputValid
  }
  
  var onTapped: (() -> Void)?
  var onRegisterButtonTapped: (() -> Void)?
  var onRegisterSuccessAction: (() -> Void)?
  
  init(viewModel: RegisterViewModel, headerView: RegisterHeaderView, footerView: AuthFooterView) {
    self.viewModel = viewModel
    self.headerView = headerView
    self.footerView = footerView
  }
  
  var body: some View {
    ZStack {
      VStack {
        headerView
        RegisterInputView(
          name: $viewModel.name,
          email: $viewModel.email,
          password: $viewModel.password
        )
        VStack {
          Spacer()
          registerButton
          footerView
        }
        .contentShape(Rectangle())
        .onTapGesture {
          onTapped?()
        }
      }
      
      if viewModel.state == .success {
        RegisterSuccessView {
          onRegisterSuccessAction?()
        }
      }
    }
    .navigationBarBackButtonHidden()
    .animation(.easeInOut(duration: 0.3), value: viewModel.state)
  }
}

// MARK: - Register Button

private extension RegisterView {
  private var registerButtonTitle: String {
    switch authButtonState {
    case .normal:
      return "Register"
    case .loading:
      return "Registering..."
    case .failed:
      return viewModel.errorTitle
    }
  }
  
  private var registerButton: some View {
    Button(registerButtonTitle) {
      onRegisterButtonTapped?()
      viewModel.register()
    }
    .buttonStyle(PrimaryButtonStyle(state: authButtonState, isEnabled: viewModel.isUserInputValid))
    .disabled(isRegisterButtonDisabled)
    .padding(.horizontal, 20)
    .padding(.bottom, 32)
  }
}

private struct FakeEmailValidator: EmailValidatorProtocol {
  func isValid(email: String) -> Bool {
    true
  }
}

private struct FakePasswordValidator: PasswordValidatorProtocol {
  func isValid(password: String) -> Bool {
    true
  }
}

private struct FakeAuthService: AuthServiceProtocol {
  func login(
    _ payload: LoginPayload,
    completion: @escaping (Result<LoginInfo, AuthError>) -> Void
  ) {
  }
  
  func createAccount(
    _ payload: CreateAccountPayload, 
    completion: @escaping (Result<Void, AuthError>) -> Void
  ) {
  }
  
  func addUser(
    _ payload: AddUserPayload,
    authToken: String,
    completion: @escaping (Result<AddedUserInfo, AuthError>) -> Void
  ) {
  }
}

#Preview {
  RegisterView(
    viewModel: RegisterViewModel(
      emailValidator: FakeEmailValidator(),
      passwordValidator: FakePasswordValidator(),
      authService: FakeAuthService()),
    headerView: RegisterHeaderView(
      onBackButtonTapped: {}
    ), footerView: AuthFooterView(
      text: "",
      buttonText: "",
      onButtonTapped: {}
    )
  )
}
