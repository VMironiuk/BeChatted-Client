//
//  SecondaryButtonStyle.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 21.03.2024.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
  private var foregroundColor: Color {
    ColorProvider.createChannelButtonForegroundColor
  }
  
  private var backgroundColor: Color {
    .white
  }
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(maxWidth: .infinity)
      .frame(height: 50)
      .foregroundStyle(foregroundColor)
      .opacity(configuration.isPressed ? 0.3 : 1)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(backgroundColor)
          .stroke(ColorProvider.createChannelButtonBorderColor)
      )
  }
}

#Preview {
  Button("Button") {
    
  }
  .buttonStyle(SecondaryButtonStyle())
  .padding(.horizontal, 20)
}
