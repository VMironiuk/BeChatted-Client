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
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    
                    Text("Sign in to your\nAccount")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color("Auth/Header/TitleColor"))
                    Text("Sign in to your Account")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color("Auth/Header/SubtitleColor"))
                }
                .padding(.bottom, 32)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 220)
            .background(Color("Auth/Header/HeaderColor"))
            
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
