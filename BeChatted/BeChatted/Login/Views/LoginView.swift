//
//  LoginView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.10.2023.
//

import SwiftUI
import BeChatted

public struct LoginViewComposer {
    private init() {}
    
    public static func composedLoginView(
        with viewModel: LoginViewModel,
        onTapped: @escaping () -> Void,
        onLoginButtonTapped: @escaping () -> Void,
        onRegisterButtonTapped: @escaping () -> Void,
        onLoginSuccessAction: @escaping () -> Void
    ) -> some View {
        var loginView = LoginView(
            viewModel: viewModel,
            footerView: LoginFooterView(onRegisterButtonTapped: onRegisterButtonTapped))
        
        loginView.onTapped = onTapped
        loginView.onLoginButtonTapped = onLoginButtonTapped
        loginView.onLoginSuccessAction = onLoginSuccessAction
        
        return loginView
    }
}

struct LoginView: View {
    @Bindable private var viewModel: LoginViewModel
    private let footerView: LoginFooterView
    
//    @EnvironmentObject var appData: AppData
    @State private var authButtonState: AuthButtonStyle.State = .normal
    
    private var errorTitle: String {
        viewModel.authError?.title ?? "Login Failed"
    }
    
    private var isLoginButtonDisabled: Bool {
        !viewModel.isUserInputValid || authButtonState == .loading || authButtonState == .failed
    }
    
    var onTapped: (() -> Void)?
    var onLoginButtonTapped: (() -> Void)?
    var onLoginSuccessAction: (() -> Void)?
    
    init(viewModel: LoginViewModel, footerView: LoginFooterView) {
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
//                    LoginFooterView()
                    footerView
                }
                .contentShape(Rectangle())
                .onTapGesture {
//                    hideKeyboard()
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
            return errorTitle
        }
    }
    
    private var button: some View {
        Button(buttonTitle) {
//            hideKeyboard()
            onLoginButtonTapped?()
            authButtonState = .loading
            viewModel.login { result in
                switch result {
                case .success:
                    authButtonState = .normal
                    DispatchQueue.main.async {
//                        appData.isUserLoggedIn = true
                        onLoginSuccessAction?()
                    }
                case .failure:
                    authButtonState = .failed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        authButtonState = .normal
                    }
                }
            }
        }
        .buttonStyle(AuthButtonStyle(state: authButtonState, isEnabled: viewModel.isUserInputValid))
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
            authService: AuthService()),
        footerView: LoginFooterView(onRegisterButtonTapped: {}))
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
}
