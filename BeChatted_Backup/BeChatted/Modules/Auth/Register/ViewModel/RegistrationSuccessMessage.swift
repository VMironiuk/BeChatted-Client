//
//  RegistrationSuccessMessage.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 09.12.2023.
//

import Foundation

struct RegistrationSuccessMessage: MessageProtocol {
    static private var appName: String {
        Bundle.main.displayNameOrEmpty
    }
    let title = "Welcome to \(appName)!"
    let description = "Congratulations, your registration is complete! "
        + "To begin connecting, chatting, and sharing moments with friends and "
        + "family, please log in to your new \(appName) account. Discover the "
        + "world of \(appName) and make every conversation count."
}
