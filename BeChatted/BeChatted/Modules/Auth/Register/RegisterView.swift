//
//  RegisterView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 28.10.2023.
//

import SwiftUI
import BeChattedAuth
import BeChattedUserInputValidation

struct RegisterView: View {
    @ObservedObject private var viewModel: RegisterViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ZStack {
                AuthHeaderView(
                    title: "Register",
                    subtitle: "Create your Account"
                )
                
                GeometryReader { geometry in
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundStyle(Color("Auth/Header/TitleColor"))
                    }
                    .offset(x: 20, y: 20)
                }
            }
            .frame(height: 180)
            
            ScrollView {
                TextInputView(title: "Your Name", text: $viewModel.name)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 64)
                
                TextInputView(title: "Email", text: $viewModel.email)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                SecureInputView(title: "Password", text: $viewModel.password)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
            }
            
            Spacer()
            
            Button("Register") {
                viewModel.register()
            }
            .buttonStyle(MainButtonStyle(isActive: viewModel.isUserInputValid))
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            
            HStack {
                Text("Already have an account?")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color("Auth/BottomLabelColor"))
                
                Button {
                    dismiss()
                } label: {
                    Text("Login")
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
        .navigationBarBackButtonHidden()
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
