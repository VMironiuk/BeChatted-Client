//
//  RegisterView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 28.10.2023.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isActive = true
    
    var body: some View {
        VStack {
            ZStack {
                AuthHeaderView(
                    title: "Register",
                    subtitle: "Create your Account"
                )
                
                GeometryReader { geometry in
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundStyle(Color("Auth/Header/TitleColor"))
                    }
                    .offset(x: 20, y: 20)
                }
            }
            .frame(height: 180)
            
            ScrollView {
                TextInputView(title: "Your Name")
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 64)
                
                TextInputView(title: "Email")
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                SecureInputView(title: "Password")
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
            }
            
            Spacer()
            
            Button("Register") {
                
            }
            .buttonStyle(MainButtonStyle(isActive: isActive))
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
            
            HStack {
                Text("Already have an account?")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color("Auth/BottomLabelColor"))
                
                Button {
                    dismiss()
                } label: {
                    Text("Login")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color("Auth/MainButtonColor"))
                }
            }
            .padding(.bottom, 40)
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    RegisterView()
}