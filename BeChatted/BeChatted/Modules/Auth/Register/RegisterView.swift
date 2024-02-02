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
                    button
                    footerView
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

// MARK: - Button

private extension RegisterView {
    private var buttonTitle: String {
        switch authButtonState {
        case .normal:
            return "Register"
        case .loading:
            return "Registering..."
        case .failed:
            return errorTitle
        }
    }
    
    private var button: some View {
        Button(buttonTitle) {
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

// MARK: - Footer View

private extension RegisterView {
    var footerView: some View {
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
}

#Preview {
    RegisterViewComposer()
        .registerView
}
