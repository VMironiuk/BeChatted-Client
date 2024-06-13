//
//  LoginView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.10.2023.
//

import SwiftUI
import BeChatted

struct LoginView: View {
//    @Bindable private var viewModel: LoginViewModel
    @State private var email = ""
    @State private var password = ""
    private let footerView: AuthFooterView
    
    @State private var authButtonState: PrimaryButtonStyle.State = .normal
    
    private var isLoginButtonDisabled: Bool {
        false /*!viewModel.isUserInputValid || authButtonState == .loading || authButtonState == .failed*/
    }
    
    var onTapped: (() -> Void)?
    var onLoginButtonTapped: (() -> Void)?
    var onLoginSuccessAction: ((String) -> Void)?
    
    init(/*viewModel: LoginViewModel, */footerView: AuthFooterView) {
//        self.viewModel = viewModel
        self.footerView = footerView
        
    }
    
    var body: some View {
        ZStack {
            VStack {
                LoginHeaderView()
                LoginInputView(email: $email /*$viewModel.email*/, password: $password /*$viewModel.password*/)
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
            return "Some Login Error" /*viewModel.errorTitle*/
        }
    }
    
    private var button: some View {
        Button(buttonTitle) {
            onLoginButtonTapped?()
            authButtonState = .loading
//            viewModel.login { result in
//                switch result {
//                case .success(let loginInfo):
//                    authButtonState = .normal
//                    DispatchQueue.main.async {
//                        onLoginSuccessAction?(loginInfo.token)
//                    }
//                case .failure:
//                    authButtonState = .failed
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        authButtonState = .normal
//                    }
//                }
//            }
        }
        .buttonStyle(PrimaryButtonStyle(state: authButtonState, isEnabled: true /*viewModel.isUserInputValid*/))
        .disabled(isLoginButtonDisabled)
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
        .animation(.easeIn(duration: 0.2), value: authButtonState)
    }
}

#Preview {
    LoginView(
//        viewModel: LoginViewModel(
//            emailValidator: EmailValidator(),
//            passwordValidator: PasswordValidator(),
//            authService: AuthService()),
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
}
