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
    
    var loginView: some View {
        LoginView(
            viewModel: LoginViewModel(
                emailValidator: EmailValidator(),
                passwordValidator: PasswordValidator(),
                authService: authServiceComposer.authService
            ), registerViewBuilder: {
                makeRegisterView()
            }
        )
    }
    
    func makeRegisterView() -> RegisterView {
        RegisterView(
            viewModel: RegisterViewModel(
                emailValidator: EmailValidator(),
                passwordValidator: PasswordValidator(),
                authService: authServiceComposer.authService,
                successMessage: RegistrationSuccessMessage()
            )
        )
    }
}
