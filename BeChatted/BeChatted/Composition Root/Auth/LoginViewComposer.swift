//
//  LoginViewComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 03.01.2024.
//

import BeChattedAuth
import BeChattedUserInputValidation

struct LoginViewComposer {
    private var authService: AuthServiceProtocol {
        AuthServiceComposer().authService
    }
    
    private var viewModel: LoginViewModel {
        LoginViewModel(
            emailValidator: EmailValidator(),
            passwordValidator: PasswordValidator(),
            authService: authService
        )
    }
    
    var loginView: LoginView {
        LoginView(viewModel: viewModel)
    }
}
