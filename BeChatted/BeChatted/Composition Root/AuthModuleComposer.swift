//
//  AuthModuleComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.11.2023.
//

import SwiftUI
import BeChattedUserInputValidation

struct AuthModuleComposer {
    private let authServiceComposer: AuthServiceComposer
    
    init(authServiceComposer: AuthServiceComposer) {
        self.authServiceComposer = authServiceComposer
    }
    
    func composeLoginView() -> LoginView {
        LoginView(
            viewModel: LoginViewModel(
                emailValidator: EmailValidator(),
                passwordValidator: PasswordValidator(),
                authService: authServiceComposer.authService
            ), registerViewBuilder: {
                composeRegisterView()
            }
        )
    }
    
    func composeRegisterView() -> RegisterView {
        RegisterView(
            viewModel: RegisterViewModel(
                emailValidator: EmailValidator(),
                passwordValidator: PasswordValidator(),
                authService: authServiceComposer.authService
            )
        )
    }
}
