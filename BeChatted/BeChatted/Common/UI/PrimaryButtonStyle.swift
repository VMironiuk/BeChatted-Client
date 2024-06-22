//
//  PrimaryButtonStyle.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.01.2024.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    enum State {
        case normal, loading, failed
    }
    
    private let state: State
    private let isEnabled: Bool
    
    private var foregroundOpacity: Double {
        isEnabled || state != .normal ? 1 : 0.8
    }
    
    private var foregroundColor: Color {
        isEnabled || state != .normal ? .white : ColorProvider.authButtonNormalColor
    }
    
    private var backgroundOpacity: Double {
        isEnabled || state != .normal ? 1 : 0.15
    }
    
    private var backgroundColor: Color {
        switch state {
        case .normal:
            return ColorProvider.authButtonNormalColor
        case .loading:
            return ColorProvider.authButtonLoadingColor
        case .failed:
            return ColorProvider.authButtonFailedColor
        }
    }
    
    init(state: State, isEnabled: Bool) {
        self.state = state
        self.isEnabled = isEnabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(.opacity(foregroundOpacity))
            .foregroundStyle(foregroundColor)
            .opacity(configuration.isPressed ? 0.3 : 1)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .opacity(backgroundOpacity)
            )
            .animation(.easeInOut(duration: 0.2), value: state)
    }
}

#Preview {
    Button("Button") {
        
    }
    .buttonStyle(PrimaryButtonStyle(state: .normal, isEnabled: true))
    .padding(.horizontal, 20)
}
