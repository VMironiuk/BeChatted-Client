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
    @ObservedObject private var navigationController: MainNavigationController
    @ObservedObject private var appData: AppData
    
    @StateObject private var loginViewModel: LoginViewModel

    init(
        navigationController: MainNavigationController,
        appData: AppData
    ) {
        self.navigationController = navigationController
        self.appData = appData
        
        _loginViewModel = StateObject(
            wrappedValue: LoginViewModel(
                emailValidator: EmailValidator(),
                passwordValidator: PasswordValidator(),
                authService: AuthServiceComposer.authService,
                onLoginSuccessAction: { authToken in
                    appData.authToken = authToken
                    appData.isUserLoggedIn = true
                }
            )
        )
    }
    
    var body: some View {
        LoginViewComposer.composedLoginView(
            with: loginViewModel,
            onTapped: { UIApplication.shared.hideKeyboard() },
            onLoginButtonTapped: { UIApplication.shared.hideKeyboard() },
            onRegisterButtonTapped: { navigationController.goToRegister() }
        )
    }
}

#Preview {
    LoginView(navigationController: MainNavigationController(), appData: AppData())
}
