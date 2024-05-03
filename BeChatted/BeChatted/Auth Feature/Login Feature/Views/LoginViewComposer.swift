//
//  LoginViewComposer.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
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
        onLoginSuccessAction: @escaping (String) -> Void
    ) -> some View {
        let footerView = AuthFooterView(
            text: "Don’t have an account?",
            buttonText: "Register",
            onButtonTapped: onRegisterButtonTapped)
        
        var loginView = LoginView(
            viewModel: viewModel,
            footerView: footerView)
        
        loginView.onTapped = onTapped
        loginView.onLoginButtonTapped = onLoginButtonTapped
        loginView.onLoginSuccessAction = onLoginSuccessAction
        
        return loginView.addKeyboardVisibilityToEnvironment()
    }
}
