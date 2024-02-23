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
    private init() {}
        
    static var loginView: some View {
        let loginViewModel = BeChattediOS.LoginViewModel(
            emailValidator: EmailValidator(),
            passwordValidator: PasswordValidator(),
            authService: AuthServiceComposer.authService)

        return LoginViewComposer.composedLoginView(
            with: loginViewModel,
            onTapped: { UIApplication.shared.hideKeyboard() },
            onLoginButtonTapped: { UIApplication.shared.hideKeyboard() },
            onRegisterButtonTapped: { print("ON TAPPED REGISTER BUTTON") },
            onLoginSuccessAction: { print("ON LOGIN SUCCES ACTION") })
    }
}


extension EmailValidator: BeChattediOS.EmailValidatorProtocol {}

extension PasswordValidator: BeChattediOS.PasswordValidatorProtocol {}

extension AuthService: BeChattediOS.AuthServiceProtocol {
    public func addUser(
        _ payload: BeChattediOS.AddUserPayload,
        authToken: String,
        completion: @escaping (Result<BeChattediOS.AddedUserInfo, BeChattediOS.AuthError>) -> Void
    ) {
    }
    
    public func login(
        _ payload: BeChattediOS.LoginPayload,
        completion: @escaping (Result<BeChattediOS.LoginInfo, BeChattediOS.AuthError>) -> Void
    ) {
    }
    
    public func createAccount(
        _ payload: BeChattediOS.CreateAccountPayload,
        completion: @escaping (Result<Void, BeChattediOS.AuthError>) -> Void
    ) {
    }
}
