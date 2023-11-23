//
//  AuthServiceComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.11.2023.
//

import BeChattedAuth

struct AuthServiceComposer {
    private static let url = URL(string: "http://dummy-url.com")!
    
    let authService = makeAuthService(
        configuration: AuthServiceConfiguration(
            newAccountURL: url,
            newUserURL: url,
            userLoginURL: url,
            userLogoutURL: url
        )
    )
}
