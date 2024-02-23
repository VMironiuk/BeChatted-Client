//
//  LoginFooterView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.02.2024.
//

import SwiftUI

struct LoginFooterViewComposer {
    private init() {}
    func composedFooterView(with registerAction: @escaping () -> Void) -> some View {
        LoginFooterView(onRegisterButtonTapped: registerAction)
    }
}

struct LoginFooterView: View {
    let onRegisterButtonTapped: () -> Void
    
    var body: some View {
        HStack {
            Text("Don’t have an account?")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(ColorProvider.authBottomLabelColor)
            
            Button {
                onRegisterButtonTapped()
            } label: {
                Text("Register")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(ColorProvider.authMainButtonColor)
            }
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    LoginFooterView {}
}
