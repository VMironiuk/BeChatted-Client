//
//  AuthView.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 15.06.2024.
//

import SwiftUI

struct AuthView: View {
    var body: some View {
        LoginView()
            .navigationDestination(for: MainNavigationController.Destination.self) { _ in
                RegisterView()
            }
    }
}

#Preview {
    AuthView()
}
