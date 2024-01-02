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
    @Environment(AuthModuleComposer.self) private var authModuleComposer
    @EnvironmentObject var appData: AppData
    
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
    ContentView()
}
