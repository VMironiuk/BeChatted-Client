//
//  RegisterViewComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 03.01.2024.
//

import BeChattedAuth
import BeChattedUserInputValidation

struct RegisterViewComposer: LoginDestinationViewsFactoryProtocol {
    private var authService: AuthServiceProtocol {
        AuthServiceComposer().authService
    }
    
    private var successMessage: MessageProtocol {
        RegistrationSuccessMessage()
    }
    
    private var registerViewModel: RegisterViewModel {
        RegisterViewModel(
            emailValidator: EmailValidator(),
            passwordValidator: PasswordValidator(),
            authService: authService,
            successMessage: successMessage
        )
    }
    
    var registerView: RegisterView {
        RegisterView(viewModel: registerViewModel)
    }
}
