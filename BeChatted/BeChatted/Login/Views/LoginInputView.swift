//
//  LoginInputView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.02.2024.
//

import SwiftUI

struct LoginInputView: View {
    private var email: Binding<String>
    private var password: Binding<String>
    
    init(email: Binding<String>, password: Binding<String>) {
        self.email = email
        self.password = password
    }
    
    var body: some View {
        VStack {
            TextInputView(title: "Email", inputType: .email, text: email)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 32)
            
            SecureInputView(title: "Password", text: password)
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 16)
        }
    }
}

#Preview {
    LoginInputView(email: .constant(""), password: .constant(""))
}
