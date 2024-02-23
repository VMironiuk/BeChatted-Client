//
//  TextInputView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 25.10.2023.
//

import SwiftUI

struct TextInputView: View {
    enum InputType {
        case `default`
        case email
    }
    
    private let title: String
    private let inputType: InputType
    @Binding private var text: String
    
    private var isEmail: Bool { inputType == .email }
    
    private var textInputAutocapitalization: TextInputAutocapitalization {
        switch inputType {
        case .default:
            return .words
        case .email:
            return .never
        }
    }
    
    init(title: String = "", inputType: InputType = .default, text: Binding<String>) {
        self.title = title
        self.inputType = inputType
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
            
            TextField("", text: $text)
                .padding(.horizontal, 20)
                .keyboardType(isEmail ? .emailAddress : .default)
                .textInputAutocapitalization(textInputAutocapitalization)
                .autocorrectionDisabled(true)
        }
    }
}

#Preview {
    TextInputView(title: "Email", text: .constant("mail@example.com"))
        .frame(height: 60)
}
