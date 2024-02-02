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
    @Bindable private var viewModel: RegisterViewModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.isKeyboardShown) var isKeyboardShown
    @State private var showRegistrationSuccessAlert = false
    @State private var authButtonState: AuthButtonStyle.State = .normal
    
    private var errorTitle: String {
        viewModel.authError?.title ?? "Registration Failed"
    }
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                RegisterHeaderView { dismiss() }
                RegisterInputView(
                    name: $viewModel.name,
                    email: $viewModel.email,
                    password: $viewModel.password
                )
                VStack {
                    Spacer()
                    registerButton
                    RegisterFooterView { dismiss() }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - Register Button

private extension RegisterView {
    private var registerButtonTitle: String {
        switch authButtonState {
        case .normal:
            return "Register"
        case .loading:
            return "Registering..."
        case .failed:
            return errorTitle
        }
    }
    
    private var registerButton: some View {
        Button(registerButtonTitle) {
            hideKeyboard()
            authButtonState = .loading
            viewModel.register { result in
                switch result {
                case .success:
                    showRegistrationSuccessAlert = true
                    authButtonState = .normal
                case .failure:
                    authButtonState = .failed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        authButtonState = .normal
                    }
                }
            }
        }
        .buttonStyle(AuthButtonStyle(state: authButtonState, isEnabled: viewModel.isUserInputValid))
        .disabled(!viewModel.isUserInputValid)
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
        .alert(
            viewModel.successMessageTitle,
            isPresented: $showRegistrationSuccessAlert,
            actions: {
                Button("OK") {
                    dismiss()
                }
            },
            message: { Text(viewModel.successMessageDescription) }
        ).animation(.easeIn(duration: 0.2), value: authButtonState)
    }
}
