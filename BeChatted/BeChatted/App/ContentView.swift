//
//  ContentView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.11.2023.
//

import SwiftUI
import BeChattedUserInputValidation

struct ContentView: View {
    var body: some View {
        NavigationStack {
            LoginView(
                viewModel: LoginViewModel(
                    emailValidator: EmailValidator(),
                    passwordValidator: PasswordValidator()
                )
            )
        }
    }
}

#Preview {
    ContentView()
}
