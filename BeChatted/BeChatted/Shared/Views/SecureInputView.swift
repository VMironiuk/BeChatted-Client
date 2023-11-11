//
//  SecureInputView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 26.10.2023.
//

import SwiftUI

struct SecureInputView: View {
    @State private var isSecured = true
    private let title: String
    @Binding private var text: String
    
    init(title: String = "", text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("Auth/UserInput/BorderColor"), lineWidth: 1)
            
            if !title.isEmpty {
                GeometryReader { geometry in
                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color(("Auth/UserInput/TitleColor")))
                        .padding(.horizontal, 8)
                        .background(Color.white)
                        .offset(x: 4, y: -8)
                }
            }
            
            HStack {
                if isSecured {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
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
    SecureInputView(title: "Password", text: .constant("0123456789"))
        .frame(height: 60)
}
