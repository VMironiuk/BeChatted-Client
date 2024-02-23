//
//  BeChattedApp.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 19.02.2024.
//

import BeChatted
import BeChattedAuth
import BeChattediOS
import BeChattedUserInputValidation
import SwiftUI

@main
struct BeChattedApp: App {
    let loginViewModel = BeChattediOS.LoginViewModel(
        emailValidator: EmailValidator(),
        passwordValidator: PasswordValidator(),
        authService: AuthServiceComposer.authService)
    
    var loginView: some View {
        LoginViewComposer.composedLoginView(
            with: loginViewModel,
            onTapped: { print("ON TAPPED") },
            onLoginButtonTapped: { print("ON TAPPED LOGIN BUTTON") },
            onRegisterButtonTapped: { print("ON TAPPED REGISTER BUTTON") },
            onLoginSuccessAction: { print("ON LOGIN SUCCES ACTION") })
    }
    
    var body: some Scene {
        WindowGroup {
            loginView
        }
    }
}

extension EmailValidator: BeChattediOS.EmailValidatorProtocol {}
extension PasswordValidator: BeChattediOS.PasswordValidatorProtocol {}
extension AuthService: BeChattediOS.AuthServiceProtocol {
    public func addUser(_ payload: BeChattediOS.AddUserPayload, authToken: String, completion: @escaping (Result<BeChattediOS.AddedUserInfo, BeChattediOS.AuthError>) -> Void) {
        
    }
    
    public func login(_ payload: BeChattediOS.LoginPayload, completion: @escaping (Result<BeChattediOS.LoginInfo, BeChattediOS.AuthError>) -> Void) {
        
    }
    
    public func createAccount(_ payload: BeChattediOS.CreateAccountPayload, completion: @escaping (Result<Void, BeChattediOS.AuthError>) -> Void) {
        
    }
}
