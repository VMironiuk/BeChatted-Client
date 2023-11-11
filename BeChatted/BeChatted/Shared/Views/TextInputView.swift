//
//  TextInputView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 25.10.2023.
//

import SwiftUI

struct TextInputView: View {
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
            
            TextField("", text: $text)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    TextInputView(title: "Email", text: .constant("mail@example.com"))
        .frame(height: 60)
}
