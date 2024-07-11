//
//  UserProfileView.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 28.06.2024.
//

import SwiftUI
import BeChatted
import BeChattediOS

struct UserProfileView: View {
  @ObservedObject private var appData: AppData
  private let onLogoutAction: () -> Void
  
  @StateObject private var viewModel: UserProfileViewModel
  
  init(appData: AppData, onLogoutAction: @escaping () -> Void) {
    self.appData = appData
    self.onLogoutAction = onLogoutAction
    
    _viewModel = StateObject(
      wrappedValue: UserProfileViewModel(
        info: UserProfileInfo(from: appData.currentUser),
        service: AuthServiceComposer.authService,
        authToken: appData.authToken ?? "",
        onLogoutAction: onLogoutAction)
    )
  }
  
  var body: some View {
    UserProfileViewComposer.composedProfileView(viewModel: viewModel)
  }
}

#Preview {
  UserProfileView(appData: AppData(), onLogoutAction: {})
}
