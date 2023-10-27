//
//  LoginView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 23.10.2023.
//

import SwiftUI

struct LoginView: View {
    @State private var isActive = true
    
    var body: some View {
        VStack {
            AuthHeaderView(
                title: "Sign in to your\nAccount",
                subtitle: "Sign in to your Account"
            )
            .frame(height: 220)
            
            ScrollView {
                TextInputView(title: "Email")
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 64)
                
                SecureInputView(title: "Password")
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
            }
            
            Spacer()
            
            Button("Login") {
                
            }
            .buttonStyle(MainButtonStyle(isActive: isActive))
            .padding(.horizontal, 20)
        }
    }    
}

#Preview {
    LoginView()
}
