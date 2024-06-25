//
//  RegisterViewComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 24.02.2024.
//

import SwiftUI
import BeChatted

public struct RegisterViewComposer {
  private init() {}
  
  public static func composedRegisterView(
    with viewModel: RegisterViewModel,
    onViewTapped: @escaping () -> Void,
    onRegisterButtonTapped: @escaping () -> Void,
    onRegisterSuccessAction: @escaping () -> Void,
    onBackButtonTapped: @escaping () -> Void,
    onLoginButtonTapped: @escaping () -> Void
  ) -> some View {
    let headerView = RegisterHeaderView(onBackButtonTapped: onBackButtonTapped)
    let footerView = AuthFooterView(
      text: "Already have an account?",
      buttonText: "Log in",
      onButtonTapped: onLoginButtonTapped)
    
    var view = RegisterView(viewModel: viewModel, headerView: headerView, footerView: footerView)
    
    view.onTapped = onViewTapped
    view.onRegisterButtonTapped = onRegisterButtonTapped
    view.onRegisterSuccessAction = onRegisterSuccessAction
    
    return view.addKeyboardVisibilityToEnvironment()
  }
}
