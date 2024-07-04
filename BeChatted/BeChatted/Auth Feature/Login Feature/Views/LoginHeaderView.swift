//
//  LoginHeaderView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.02.2024.
//

import SwiftUI

struct LoginHeaderView: View {
  @Environment(\.isKeyboardShown) var isKeyboardShown
  
  var body: some View {
    VStack {
      if !isKeyboardShown {
        AuthHeaderView(
          title: "Sign in to your\nAccount",
          subtitle: "Sign in to your Account"
        )
        .frame(height: 180)
        .transition(.offset(y: -260))
      }
    }
  }
}

#Preview {
  LoginHeaderView()
}
