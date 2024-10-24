//
//  AuthHeaderView.swift
//  Prototype
//
//  Created by Volodymyr Myroniuk on 24.10.2023.
//

import SwiftUI

struct AuthHeaderView: View {
  let title: String
  let subtitle: String
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 20) {
        Spacer()
        
        Text(title)
          .font(.system(size: 24, weight: .semibold))
          .foregroundStyle(ColorProvider.authHeaderTitleColor)
        Text(subtitle)
          .font(.system(size: 12, weight: .regular))
          .foregroundStyle(ColorProvider.authHeaderSubtitleColor)
      }
      .padding(.bottom, 32)
      
      Spacer()
    }
    .padding(.horizontal, 20)
    .background(ColorProvider.authHeaderColor)
  }
}

#Preview {
  AuthHeaderView(
    title: "Sign in to your\nAccount",
    subtitle: "Sign in to your Account"
  )
}
