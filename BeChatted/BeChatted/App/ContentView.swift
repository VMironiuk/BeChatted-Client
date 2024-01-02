//
//  ContentView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.11.2023.
//

import SwiftUI
import BeChattedAuth
import BeChattedUserInputValidation

struct ContentView: View {
    private let authModuleComposer: AuthModuleComposer
    @EnvironmentObject var appData: AppData
    
    init(authModuleComposer: AuthModuleComposer) {
        self.authModuleComposer = authModuleComposer
    }
    
    var body: some View {
        NavigationStack {
            if appData.isUserLoggedIn {
                DummyChatsView()
            } else {
                authModuleComposer.loginView
            }
        }
    }
}

#Preview {
    ContentView(
        authModuleComposer: AuthModuleComposer(
            authServiceComposer: AuthServiceComposer()
        )
    )
}
