//
//  TextInputView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 25.10.2023.
//

import SwiftUI

struct TextInputView: View {
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
            
            TextField("", text: .constant("mail@example.com"))
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    TextInputView(title: "Email")
        .frame(height: 60)
}
