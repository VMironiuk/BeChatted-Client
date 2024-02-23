//
//  RegisterInputView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.02.2024.
//

//import SwiftUI
//
//struct RegisterInputView: View {
//    private var name: Binding<String>
//    private var email: Binding<String>
//    private var password: Binding<String>
//    
//    init(name: Binding<String>, email: Binding<String>, password: Binding<String>) {
//        self.name = name
//        self.email = email
//        self.password = password
//    }
//    
//    var body: some View {
//        VStack {
//            TextInputView(title: "Your Name", text: name)
//                .frame(height: 50)
//                .padding(.horizontal, 20)
//                .padding(.top, 32)
//            
//            TextInputView(title: "Email", inputType: .email, text: email)
//                .frame(height: 50)
//                .padding(.horizontal, 20)
//                .padding(.top, 16)
//            
//            SecureInputView(title: "Password", text: password)
//                .frame(height: 50)
//                .padding(.horizontal, 20)
//                .padding(.top, 16)
//        }
//    }
//}
//
//#Preview {
//    RegisterInputView(name: .constant(""), email: .constant(""), password: .constant(""))
//}
