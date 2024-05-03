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
            authService: AuthServiceComposer.authService)
        
        return RegisterViewComposer.composedRegisterView(
            with: viewModel,
            onViewTapped: { UIApplication.shared.hideKeyboard() },
            onRegisterButtonTapped: { UIApplication.shared.hideKeyboard() },
            onRegisterSuccessAction: { navigationController.pop() },
            onBackButtonTapped: { navigationController.pop() },
            onLoginButtonTapped: { navigationController.pop() })
    }
}
