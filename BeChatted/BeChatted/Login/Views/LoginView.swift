//
//  LoginView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 23.10.2023.
//

//import SwiftUI
//
//struct LoginView: View {
//    @Bindable private var viewModel: LoginViewModel
//    
//    @EnvironmentObject var appData: AppData
//    @State private var authButtonState: AuthButtonStyle.State = .normal
//    
//    private var errorTitle: String {
//        viewModel.authError?.title ?? "Login Failed"
//    }
//    
//    private var isLoginButtonDisabled: Bool {
//        !viewModel.isUserInputValid || authButtonState == .loading || authButtonState == .failed
//    }
//    
//    init(viewModel: LoginViewModel) {
//        self.viewModel = viewModel
//    }
//    
//    var body: some View {
//        ZStack {
//            VStack {
//                LoginHeaderView()
//                LoginInputView(email: $viewModel.email, password: $viewModel.password)
//                VStack {
//                    Spacer()
//                    button
//                    LoginFooterView()
//                }
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    hideKeyboard()
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Login Button
//
//private extension LoginView {
//    private var buttonTitle: String {
//        switch authButtonState {
//        case .normal:
//            return "Login"
//        case .loading:
//            return "Logging In..."
//        case .failed:
//            return errorTitle
//        }
//    }
//    
//    private var button: some View {
//        Button(buttonTitle) {
//            hideKeyboard()
//            authButtonState = .loading
//            viewModel.login { result in
//                switch result {
//                case .success:
//                    authButtonState = .normal
//                    DispatchQueue.main.async {
//                        appData.isUserLoggedIn = true
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
//        .disabled(isLoginButtonDisabled)
//        .padding(.horizontal, 20)
//        .padding(.bottom, 32)
//        .animation(.easeIn(duration: 0.2), value: authButtonState)
//    }
//}
//
//#Preview {
//    LoginViewComposer()
//        .loginView
//}
