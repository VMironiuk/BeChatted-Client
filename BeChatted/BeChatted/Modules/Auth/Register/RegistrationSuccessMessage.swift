//
//  RegistrationSuccessMessage.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 09.12.2023.
//

import Foundation

struct RegistrationSuccessMessage {
    private init() {}
    
    // TODO: fetch the app's name from the bundle
    static let title = "Welcome to BeChatted!"
    static let description = "Congratulations, your registration is complete! "
        + "To begin connecting, chatting, and sharing moments with friends and "
        + "family, please log in to your new BeChatted account. Discover the "
        + "world of BeChatted and make every conversation count."
}
