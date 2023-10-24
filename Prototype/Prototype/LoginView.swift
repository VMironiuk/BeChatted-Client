//
//  LoginView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 23.10.2023.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            AuthHeaderView(
                title: "Sign in to your\nAccount",
                subtitle: "Sign in to your Account"
            )
            .frame(height: 220)
            
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
