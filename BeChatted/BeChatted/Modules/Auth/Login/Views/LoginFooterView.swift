//
//  LoginFooterView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.02.2024.
//

import SwiftUI

struct LoginFooterView: View {
    private let destinationsFactory: LoginDestinationViewsFactoryProtocol
    
    private var registerView: some View {
        destinationsFactory.registerView.addKeyboardVisibilityToEnvironment()
    }
    
    init(destinationsFactory: LoginDestinationViewsFactoryProtocol) {
        self.destinationsFactory = destinationsFactory
    }
    
    var body: some View {
        HStack {
            Text("Don’t have an account?")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color("Auth/BottomLabelColor"))
            
            NavigationLink(destination: registerView) {
                Text("Register")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color("Auth/MainButtonColor"))
            }
        }
        .padding(.bottom, 40)
    }
}

private struct FakeRegisterView: LoginDestinationViewsFactoryProtocol {
    var registerView: RegisterView { RegisterViewComposer().registerView }
}

#Preview {
    LoginFooterView(destinationsFactory: FakeRegisterView())
}
