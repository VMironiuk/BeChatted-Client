//
//  AuthFooterView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 24.02.2024.
//

import SwiftUI

struct AuthFooterView: View {
  let text: String
  let buttonText: String
  let onButtonTapped: () -> Void
  
  var body: some View {
    HStack {
      Text(text)
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(Color("Auth/BottomLabelColor"))
      
      Button {
        onButtonTapped()
      } label: {
        Text(buttonText)
          .font(.system(size: 14, weight: .regular))
          .foregroundStyle(Color("Auth/MainButtonColor"))
      }
    }
    .padding(.bottom, 40)
  }
}

#Preview {
  AuthFooterView(text: "Already have an account?", buttonText: "Login") {}
}
