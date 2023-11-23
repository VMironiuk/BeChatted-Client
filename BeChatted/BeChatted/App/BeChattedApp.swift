//
//  BeChattedApp.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.11.2023.
//

import SwiftUI

@main
struct BeChattedApp: App {
    private let authModuleComposer = AuthModuleComposer(authServiceComposer: AuthServiceComposer())
    
    var body: some Scene {
        WindowGroup {
            ContentView(authModuleComposer: authModuleComposer)
        }
    }
}
