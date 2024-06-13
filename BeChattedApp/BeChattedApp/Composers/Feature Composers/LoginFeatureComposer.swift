//
//  LoginFeatureComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import SwiftUI
import BeChatted
import BeChattedAuth
import BeChattediOS
import BeChattedUserInputValidation

struct LoginFeatureComposer {
    let navigationController: MainNavigationController
    let appData: AppData
    
    var loginView: some View {
        let loginViewModel = LoginViewModel(
            emailValidator: EmailValidator(),
            passwordValidator: PasswordValidator(),
            authService: AuthServiceComposer.authService)

        return LoginViewComposer.composedLoginView(
            with: loginViewModel,
            onTapped: { UIApplication.shared.hideKeyboard() },
            onLoginButtonTapped: {
                UIApplication.shared.hideKeyboard()
                appData.isUserLoggedIn = true
            },
            onRegisterButtonTapped: { navigationController.goToRegister() },
            onLoginSuccessAction: { authToken in
                appData.authToken = authToken
                appData.isUserLoggedIn = true
            }
        )
    }
}
