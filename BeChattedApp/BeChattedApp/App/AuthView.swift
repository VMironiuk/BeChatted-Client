//
//  AuthView.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 15.06.2024.
//

import SwiftUI

struct AuthView: View {
  @EnvironmentObject private var navigationController: MainNavigationController
  @EnvironmentObject private var appData: AppData
  
  var body: some View {
    LoginView(navigationController: navigationController, appData: appData)
      .navigationDestination(for: MainNavigationController.Destination.self) { _ in
        RegisterView()
      }
  }
}

#Preview {
  AuthView()
}
