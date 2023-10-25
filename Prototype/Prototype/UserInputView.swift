//
//  UserInputView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 25.10.2023.
//

import SwiftUI

struct UserInputView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextField("", text: .constant("example@mail.com"))
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("Auth/UserInput/BorderColor"), lineWidth: 1)
                        .frame(height: 50)
                )
            
            Text("Email")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(("Auth/UserInput/TitleColor")))
                .padding(.horizontal, 8)
                .background(Color.white)
                .offset(x: 4, y: -20)
        }
    }
}

#Preview {
    UserInputView()
}
