//
//  ProfileView.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 28.06.2024.
//

import SwiftUI
import BeChatted
import BeChattediOS

struct ProfileView: View {
  @ObservedObject private var appData: AppData
  private let onLogoutAction: () -> Void
  
  @StateObject private var viewModel: ProfileViewModel
  
  init(appData: AppData, onLogoutAction: @escaping () -> Void) {
    self.appData = appData
    self.onLogoutAction = onLogoutAction
    
    _viewModel = StateObject(
      wrappedValue: ProfileViewModel(
        service: AuthServiceComposer.authService,
        authToken: appData.authToken ?? "",
        onLogoutAction: onLogoutAction)
    )
  }
  
  var body: some View {
    ProfileViewComposer.composedProfileView(viewModel: viewModel)
  }
}

#Preview {
  ProfileView(appData: AppData(), onLogoutAction: {})
}
