//
//  RegisterSuccessView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 03.02.2024.
//

import SwiftUI

struct RegisterSuccessView: View {
  private let action: () -> Void
  
  @State private var imageScale: CGFloat = 0.0
  
  init(action: @escaping () -> Void) {
    self.action = action
  }
  
  var body: some View {
    VStack {
      Spacer()
      
      ImageProvider.authRegistrationSuccessImage
        .resizable()
        .scaleEffect(imageScale)
        .frame(width: 100, height: 100)
        .onAppear {
          withAnimation(.easeInOut(duration: 0.3).delay(0.3)) {
            imageScale = 1.0
          }
        }
      
      Text("Registration Successful!")
        .padding(.top, 40)
        .padding(.bottom)
        .padding(.horizontal, 20)
        .font(.system(size: 24, weight: .semibold))
      
      Text(" Welcome to BeChatted app.\nYou're all set to begin your journey with us")
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
        .font(.system(size: 20, weight: .regular))
        .foregroundStyle(ColorProvider.authRegistrationSuccessLabelColor)
      
      Spacer()
      
      Button("Proceed to Login") {
        action()
      }
      .buttonStyle(PrimaryButtonStyle(state: .normal, isEnabled: true))
      .padding(.horizontal, 20)
      .padding(.vertical, 60)
    }
    .background(.white)
    .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top)))
  }
}

#Preview {
  RegisterSuccessView {}
}
