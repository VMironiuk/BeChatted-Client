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
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        if appData.isUserLoggedIn {
            DummyChatsView()
        } else {
            LoginViewComposer().loginView
        }
    }
}

#Preview {
    ContentView()
}
