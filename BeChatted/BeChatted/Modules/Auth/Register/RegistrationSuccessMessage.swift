//
//  RegistrationSuccessMessage.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 09.12.2023.
//

import Foundation

struct RegistrationSuccessMessage: MessageProtocol {
    // TODO: fetch the app's name from the bundle
    let title = "Welcome to BeChatted!"
    let description = "Congratulations, your registration is complete! "
        + "To begin connecting, chatting, and sharing moments with friends and "
        + "family, please log in to your new BeChatted account. Discover the "
        + "world of BeChatted and make every conversation count."
}
