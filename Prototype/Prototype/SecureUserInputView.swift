//
//  SecureUserInputView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 26.10.2023.
//

import SwiftUI

struct SecureUserInputView: View {
    @State private var isSecured = true
    let title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("Auth/UserInput/BorderColor"), lineWidth: 1)
            
            GeometryReader { geometry in
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(("Auth/UserInput/TitleColor")))
                    .padding(.horizontal, 8)
                    .background(Color.white)
                    .offset(x: 4, y: -8)
            }
            
            HStack {
                if isSecured {
                    SecureField("", text: .constant("0123456789"))
                } else {
                    TextField("", text: .constant("0123456789"))
                }
                Button(action: {
                    isSecured.toggle()
                }, label: {
                    Image(isSecured
                          ? "Auth/UserInput/HiddenPasswordIcon"
                          : "Auth/UserInput/ShownPasswordIcon"
                    )
                })
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    SecureUserInputView(title: "Password")
        .frame(height: 60)
}
