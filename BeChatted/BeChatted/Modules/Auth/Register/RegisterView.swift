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
    @State private var showErrorAlert = false
    @State private var showRegistrationSuccessAlert = false
    @State private var showLoadingView = false
    @State private var authButtonState: AuthButtonStyle.State = .normal
    
    private var errorTitle: String {
        viewModel.authError?.title ?? ""
    }
    
    private var errorDescription: String {
        viewModel.authError?.description ?? ""
    }
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                inputView
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
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

extension RegisterView {
    private var headerView: some View {
        VStack {
            if !isKeyboardShown {
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
                .transition(.offset(y: -260))
            }
        }
    }
    
    private var inputView: some View {
        VStack {
            TextInputView(title: "Your Name", text: $viewModel.name)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 32)
            
            TextInputView(title: "Email", inputType: .email, text: $viewModel.email)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            SecureInputView(title: "Password", text: $viewModel.password)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 16)
        }
    }
    
    private var buttonTitle: String {
        switch authButtonState {
        case .normal:
            return "Register"
        case .loading:
            return "Registering..."
        case .failed:
            return "Registration Failed"
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
