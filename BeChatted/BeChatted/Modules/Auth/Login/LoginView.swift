//
//  LoginView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 23.10.2023.
//

import SwiftUI
import BeChattedUserInputValidation

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            AuthHeaderView(
                title: "Sign in to your\nAccount",
                subtitle: "Sign in to your Account"
            )
            .frame(height: 180)
            
            ScrollView {
                TextInputView(title: "Email", text: $viewModel.email)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 64)
                
                SecureInputView(title: "Password", text: $viewModel.password)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
            }
            
            Spacer()
            
            Button("Login") {
                
            }
            .buttonStyle(MainButtonStyle(isActive: viewModel.isUserInputValid))
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            
            HStack {
                Text("Don’t have an account?")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color("Auth/BottomLabelColor"))
                
                NavigationLink(destination: RegisterView()) {
                    Text("Register")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color("Auth/MainButtonColor"))
                    
                }
            }
            .padding(.bottom, 40)
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    LoginView(
        viewModel: LoginViewModel(
            emailValidator: EmailValidator(),
            passwordValidator: PasswordValidator()
        )
    )
}
