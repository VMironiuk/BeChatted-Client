//
//  LoginView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 23.10.2023.
//

import SwiftUI
import BeChattedAuth
import BeChattedUserInputValidation

struct LoginView: View {
    @Bindable private var viewModel: LoginViewModel
    private let destinationsFactory: LoginDestinationViewsFactoryProtocol
    
    @EnvironmentObject var appData: AppData
    @State private var authButtonState: AuthButtonStyle.State = .normal
    
    private var registerView: some View {
        destinationsFactory.registerView.addKeyboardVisibilityToEnvironment()
    }
    
    private var errorTitle: String {
        viewModel.authError?.title ?? "Login Failed"
    }
    
    init(
        viewModel: LoginViewModel,
        destinationsFactory: LoginDestinationViewsFactoryProtocol
    ) {
        self.viewModel = viewModel
        self.destinationsFactory = destinationsFactory
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
                    hideKeyboard()
                }
            }
        }
    }
}

// MARK: - Button

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
            hideKeyboard()
            authButtonState = .loading
            viewModel.login { result in
                switch result {
                case .success:
                    authButtonState = .normal
                    DispatchQueue.main.async {
                        appData.isUserLoggedIn = true
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
        .disabled(!viewModel.isUserInputValid)
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
        .animation(.easeIn(duration: 0.2), value: authButtonState)
    }
}

// MARK: - Footer View

private extension LoginView {
    private var footerView: some View {
        HStack {
            Text("Don’t have an account?")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color("Auth/BottomLabelColor"))
            
            NavigationLink(destination: registerView) {
                Text("Register")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color("Auth/MainButtonColor"))
            }
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    LoginViewComposer()
        .loginView
}
