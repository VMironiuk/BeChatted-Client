//
//  RegisterView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 28.10.2023.
//

import SwiftUI
import BeChatted

struct RegisterView: View {
    @ObservedObject private var viewModel: RegisterViewModel
    private let headerView: RegisterHeaderView
    private let footerView: AuthFooterView
    
    @Environment(\.isKeyboardShown) var isKeyboardShown
    @State private var isRegistrationSucceeded = false
    @State private var authButtonState: PrimaryButtonStyle.State = .normal
    
    private var isRegisterButtonDisabled: Bool {
        !viewModel.isUserInputValid || authButtonState == .loading || authButtonState == .failed
    }
    
    var onTapped: (() -> Void)?
    var onRegisterButtonTapped: (() -> Void)?
    var onRegisterSuccessAction: (() -> Void)?
    
    init(viewModel: RegisterViewModel, headerView: RegisterHeaderView, footerView: AuthFooterView) {
        self.viewModel = viewModel
        self.headerView = headerView
        self.footerView = footerView
    }
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                RegisterInputView(
                    name: $viewModel.name,
                    email: $viewModel.email,
                    password: $viewModel.password
                )
                VStack {
                    Spacer()
                    registerButton
                    footerView
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onTapped?()
                }
            }
            
            if isRegistrationSucceeded {
                RegisterSuccessView {
                    onRegisterSuccessAction?()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isRegistrationSucceeded = false
                    }
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
            return viewModel.errorTitle
        }
    }
    
    private var registerButton: some View {
        Button(registerButtonTitle) {
            onRegisterButtonTapped?()
            authButtonState = .loading
            viewModel.register { result in
                switch result {
                case .success:
                    authButtonState = .normal
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isRegistrationSucceeded = true
                    }
                case .failure:
                    authButtonState = .failed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        authButtonState = .normal
                    }
                }
            }
        }
        .buttonStyle(PrimaryButtonStyle(state: authButtonState, isEnabled: viewModel.isUserInputValid))
        .disabled(isRegisterButtonDisabled)
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
        .animation(.easeIn(duration: 0.2), value: authButtonState)
    }
}
