//
//  LoginView.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 15.06.2024.
//

import SwiftUI
import BeChatted
import BeChattediOS
import BeChattedUserInputValidation

struct LoginView: View {
    @EnvironmentObject private var navigationController: MainNavigationController
    @EnvironmentObject private var appData: AppData
    
    @StateObject private var loginViewModel = LoginViewModel(
        emailValidator: EmailValidator(),
        passwordValidator: PasswordValidator(),
        authService: AuthServiceComposer.authService
    )

    
    var body: some View {
        LoginViewComposer.composedLoginView(
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

#Preview {
    LoginView()
}
