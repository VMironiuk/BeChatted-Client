//
//  MainButtonStyles.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 27.10.2023.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    private let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
    }
    
    func makeBody(configuration: Configuration) -> some View {
        if isActive {
            configuration.label
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundStyle(.white)
                .opacity(configuration.isPressed ? 0.3 : 1)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("Auth/MainButtonColor"))
                )
        } else {
            configuration.label
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundStyle(.opacity(0.8))
                .foregroundStyle(Color("Auth/MainButtonColor"))
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("Auth/MainButtonColor"))
                        .opacity(0.15)
                )
                .disabled(true)
        }
    }
}

#Preview {
    Button("Button") {
        
    }
    .buttonStyle(MainButtonStyle(isActive: true))
    .padding(.horizontal, 20)
}
