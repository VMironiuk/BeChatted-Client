//
//  RegisterFeatureComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 24.02.2024.
//

import BeChatted
import BeChattedAuth
import BeChattedUserInputValidation
import BeChattediOS
import SwiftUI

struct RegisterFeatureComposer {
    let navigationController: MainNavigationController
    
    var registerView: some View {
        let viewModel = RegisterViewModel(
            emailValidator: EmailValidator(),
            passwordValidator: PasswordValidator(),
            authService: AuthServiceComposer.authService, 
            successMessage: RegistrationSuccessMessage())
        
        return RegisterViewComposer.composedRegisterView(
            with: viewModel,
            onViewTapped: { UIApplication.shared.hideKeyboard() },
            onRegisterButtonTapped: { UIApplication.shared.hideKeyboard() },
            onRegisterSuccessAction: { navigationController.pop() },
            onBackButtonTapped: { navigationController.pop() },
            onLoginButtonTapped: { navigationController.pop() })
    }
}

private struct RegistrationSuccessMessage: MessageProtocol {
    static private var appName: String {
        Bundle.main.displayNameOrEmpty
    }
    let title = "Welcome to \(appName)!"
    let description = "Congratulations, your registration is complete! "
        + "To begin connecting, chatting, and sharing moments with friends and "
        + "family, please log in to your new \(appName) account. Discover the "
        + "world of \(appName) and make every conversation count."
}
