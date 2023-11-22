//
//  ContentView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.11.2023.
//

import SwiftUI
import BeChattedAuth
import BeChattedUserInputValidation

struct ContentView: View {
    var body: some View {
        NavigationStack {
            LoginView(
                viewModel: LoginViewModel(
                    emailValidator: EmailValidator(),
                    passwordValidator: PasswordValidator(),
                    authService: makeAuthService(
                        configuration: AuthServiceConfiguration(
                            newAccountURL: URL(string: "http://new-account.com")!,
                            newUserURL: URL(string: "http://new-user.com")!,
                            userLoginURL: URL(string: "http://user-login.com")!,
                            userLogoutURL: URL(string: "http://user-logout.com")!
                        )
                    )
                ), registerViewBuilder: {
                    RegisterView(
                        viewModel: RegisterViewModel(
                            emailValidator: EmailValidator(),
                            passwordValidator: PasswordValidator(),
                            authService: makeAuthService(
                                configuration: AuthServiceConfiguration(
                                    newAccountURL: URL(string: "http://new-account.com")!,
                                    newUserURL: URL(string: "http://new-user.com")!,
                                    userLoginURL: URL(string: "http://user-login.com")!,
                                    userLogoutURL: URL(string: "http://user-logout.com")!
                                )
                            )
                        )
                    )
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
