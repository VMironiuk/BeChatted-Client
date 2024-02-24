//
//  BeChattedApp.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 19.02.2024.
//

import BeChatted
import BeChattedAuth
import BeChattediOS
import BeChattedUserInputValidation
import SwiftUI

@main
struct BeChattedApp: App {
    var body: some Scene {
        WindowGroup {
            RegisterFeatureComposer.registerView
        }
    }
}
