//
//  RegisterFooterView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.02.2024.
//

import SwiftUI

struct RegisterFooterView: View {
    private let loginButtonAction: () -> Void
    
    init(_ loginButtonAction: @escaping () -> Void) {
        self.loginButtonAction = loginButtonAction
    }
    
    var body: some View {
        HStack {
            Text("Already have an account?")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color("Auth/BottomLabelColor"))
            
            Button {
                loginButtonAction()
            } label: {
                Text("Login")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color("Auth/MainButtonColor"))
            }
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    RegisterFooterView {}
}
