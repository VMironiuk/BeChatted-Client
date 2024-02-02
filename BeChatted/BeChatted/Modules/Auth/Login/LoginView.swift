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
    @Environment(\.isKeyboardShown) var isKeyboardShown
    @State private var showErrorAlert = false
    @State private var authButtonState: AuthButtonStyle.State = .normal
    
    private var registerView: some View {
        destinationsFactory.registerView.addKeyboardVisibilityToEnvironment()
    }
    
    private var errorTitle: String {
        viewModel.authError?.title ?? "Login Failed"
    }
    
    private var errorDescription: String {
        viewModel.authError?.description ?? ""
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
                headerView
                inputView
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
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

extension LoginView {
    private var headerView: some View {
        VStack {
            if !isKeyboardShown {
                AuthHeaderView(
                    title: "Sign in to your\nAccount",
                    subtitle: "Sign in to your Account"
                )
                .frame(height: 180)
                .transition(.offset(y: -260))
            }
        }
    }
    
    private var inputView: some View {
        VStack {
            TextInputView(title: "Email", inputType: .email, text: $viewModel.email)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 32)
            
            SecureInputView(title: "Password", text: $viewModel.password)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 16)
        }
    }
    
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
