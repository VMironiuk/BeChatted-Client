//
//  RegisterFooterView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.02.2024.
//

import SwiftUI

struct RegisterFooterView: View {
    @EnvironmentObject var mainNavigationController: MainNavigationController
    
    var body: some View {
        HStack {
            Text("Already have an account?")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color("Auth/BottomLabelColor"))
            
            Button {
                mainNavigationController.pop()
            } label: {
                Text("Login")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color("Auth/MainButtonColor"))
            }
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    RegisterFooterView()
}
