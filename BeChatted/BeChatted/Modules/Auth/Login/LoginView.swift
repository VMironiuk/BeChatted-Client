//
//  LoginView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 23.10.2023.
//

import SwiftUI
import BeChattedAuth
import BeChattedUserInputValidation

struct LoginView: View {
    @Bindable private var viewModel: LoginViewModel
    private let destinationsFactory: LoginDestinationViewsFactoryProtocol
    
    @EnvironmentObject var appData: AppData
    @Environment(\.isKeyboardShown) var isKeyboardShown
    @State private var showErrorAlert = false
    @State private var showLoadingView = false
    
    private var registerView: some View {
        destinationsFactory.registerView
    }
    
    private var errorTitle: String {
        viewModel.authError?.title ?? ""
    }
    
    private var errorDescription: String {
        viewModel.authError?.description ?? ""
    }
    
    init(
        viewModel: LoginViewModel,
        destinationsFactory: LoginDestinationViewsFactoryProtocol
    ) {
        self.viewModel = viewModel
        self.destinationsFactory = destinationsFactory
    }
    
    var body: some View {
        ZStack {
            VStack {
                AuthHeaderView(
                    title: "Sign in to your\nAccount",
                    subtitle: "Sign in to your Account"
                )
                .offset(y: isKeyboardShown ? -220 : 0)
                .animation(.easeOut, value: isKeyboardShown)
                .frame(height: 180)
                
                Spacer()
                                
                TextInputView(title: "Email", inputType: .email, text: $viewModel.email)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                
                SecureInputView(title: "Password", text: $viewModel.password)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                Spacer(minLength: 16)
                
                Button("Login") {
                    showLoadingView = true
                    viewModel.login { result in
                        showLoadingView = false
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                appData.isUserLoggedIn = true
                            }
                        case .failure:
                            showErrorAlert = true
                        }
                    }
                }
                .buttonStyle(MainButtonStyle(isActive: viewModel.isUserInputValid))
                .disabled(!viewModel.isUserInputValid)
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
                .alert(
                    errorTitle,
                    isPresented: $showErrorAlert,
                    actions: {},
                    message: { Text(errorDescription) }
                )
                
                HStack {
                    Text("Don’t have an account?")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color("Auth/BottomLabelColor"))
                    
                    NavigationLink(destination: registerView) {
                        Text("Register")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color("Auth/MainButtonColor"))
                    }
                }
                .padding(.bottom, 40)
            }
            
            if showLoadingView {
                ProgressView()
            }
        }
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
    LoginViewComposer()
        .loginView
}
