//
//  LoginViewComposer.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import SwiftUI

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
