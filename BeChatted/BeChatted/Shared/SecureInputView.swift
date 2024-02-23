//
//  SecureInputView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 26.10.2023.
//

import SwiftUI

struct SecureInputView: View {
    private let title: String
    @Binding private var text: String
    
    init(title: String = "", text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorProvider.authUserInputBorderColor, lineWidth: 1)
            
            if !title.isEmpty {
                GeometryReader { geometry in
                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(ColorProvider.authUserInputTitleColor)
                        .padding(.horizontal, 8)
                        .background(Color.white)
                        .offset(x: 4, y: -8)
                }
            }
            
            SecureField("", text: $text)
                .padding(.horizontal, 20)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
        }
    }
}

#Preview {
    SecureInputView(title: "Password", text: .constant("0123456789"))
        .frame(height: 60)
}
