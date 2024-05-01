//
//  LoginFeatureComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import BeChattedAuth
import BeChattediOS
import BeChattedUserInputValidation
import SwiftUI

struct LoginFeatureComposer {
    let navigationController: MainNavigationController
    let appData: AppData
    
    var loginView: some View {
        let loginViewModel = BeChattediOS.LoginViewModel(
            emailValidator: EmailValidator(),
            passwordValidator: PasswordValidator(),
            authService: AuthServiceComposer.authService)

        return LoginViewComposer.composedLoginView(
            with: loginViewModel,
            onTapped: { UIApplication.shared.hideKeyboard() },
            onLoginButtonTapped: { UIApplication.shared.hideKeyboard() },
            onRegisterButtonTapped: { navigationController.goToRegister() },
            onLoginSuccessAction: { authToken in
                appData.authToken = authToken
                appData.isUserLoggedIn = true
            }
        )
    }
}
