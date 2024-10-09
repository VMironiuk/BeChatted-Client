//
//  RegisterView.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 15.06.2024.
//

import SwiftUI
import BeChatted
import BeChattediOS
import BeChattedUserInputValidation

struct RegisterView: View {
  @EnvironmentObject private var navigationController: MainNavigationController
  
  @StateObject private var registerViewModel = RegisterViewModel(
    emailValidator: EmailValidatorWrapper(emailValidator: EmailValidator()),
    passwordValidator: PasswordValidatorWrapper(passwordValidator: PasswordValidator()),
    authService: AuthServiceComposer.authService
  )
  
  var body: some View {
    RegisterViewComposer.composedRegisterView(
      with: registerViewModel,
      onViewTapped: { UIApplication.shared.hideKeyboard() },
      onRegisterButtonTapped: { UIApplication.shared.hideKeyboard() },
      onRegisterSuccessAction: { navigationController.pop() },
      onBackButtonTapped: { navigationController.pop() },
      onLoginButtonTapped: { navigationController.pop() })
  }
}

#Preview {
  RegisterView()
}
