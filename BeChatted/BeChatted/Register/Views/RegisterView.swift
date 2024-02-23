//
//  RegisterView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 28.10.2023.
//

//import SwiftUI
//import BeChattedAuth
//import BeChattedUserInputValidation
//
//struct RegisterView: View {
//    @Bindable private var viewModel: RegisterViewModel
//    
//    @EnvironmentObject var mainNNavigationController: MainNavigationController
//    @Environment(\.isKeyboardShown) var isKeyboardShown
//    @State private var isRegistrationSucceeded = false
//    @State private var authButtonState: AuthButtonStyle.State = .normal
//    
//    private var errorTitle: String {
//        viewModel.authError?.title ?? "Registration Failed"
//    }
//    
//    private var isRegisterButtonDisabled: Bool {
//        !viewModel.isUserInputValid || authButtonState == .loading || authButtonState == .failed
//    }
//    
//    init(viewModel: RegisterViewModel) {
//        self.viewModel = viewModel
//    }
//    
//    var body: some View {
//        ZStack {
//            VStack {
//                RegisterHeaderView()
//                RegisterInputView(
//                    name: $viewModel.name,
//                    email: $viewModel.email,
//                    password: $viewModel.password
//                )
//                VStack {
//                    Spacer()
//                    registerButton
//                    RegisterFooterView()
//                }
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    hideKeyboard()
//                }
//            }
//            
//            if isRegistrationSucceeded {
//                RegisterSuccessView {
//                    mainNNavigationController.pop()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        isRegistrationSucceeded = false
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//    }
//}
//
//// MARK: - Register Button
//
//private extension RegisterView {
//    private var registerButtonTitle: String {
//        switch authButtonState {
//        case .normal:
//            return "Register"
//        case .loading:
//            return "Registering..."
//        case .failed:
//            return errorTitle
//        }
//    }
//    
//    private var registerButton: some View {
//        Button(registerButtonTitle) {
//            hideKeyboard()
//            authButtonState = .loading
//            viewModel.register { result in
//                switch result {
//                case .success:
//                    authButtonState = .normal
//                    withAnimation(.easeInOut(duration: 0.3)) {
//                        isRegistrationSucceeded = true
//                    }
//                case .failure:
//                    authButtonState = .failed
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        authButtonState = .normal
//                    }
//                }
//            }
//        }
//        .buttonStyle(AuthButtonStyle(state: authButtonState, isEnabled: viewModel.isUserInputValid))
//        .disabled(isRegisterButtonDisabled)
//        .padding(.horizontal, 20)
//        .padding(.bottom, 32)
//        .animation(.easeIn(duration: 0.2), value: authButtonState)
//    }
//}
