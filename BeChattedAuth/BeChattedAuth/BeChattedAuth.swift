//
//  BeChattedAuth.swift
//  BeChattedAuth
//
//  Created by Volodymyr Myroniuk on 01.11.2023.
//

import Foundation

public struct AuthServiceConfiguration {
    let newAccountURL: URL
    let newUserURL: URL
    let userLoginURL: URL
    let userLogoutURL: URL
    
    public init(newAccountURL: URL, newUserURL: URL, userLoginURL: URL, userLogoutURL: URL) {
        self.newAccountURL = newAccountURL
        self.newUserURL = newUserURL
        self.userLoginURL = userLoginURL
        self.userLogoutURL = userLogoutURL
    }
}

public func makeAuthService(configuration: AuthServiceConfiguration) -> AuthService {
    AuthService(
        newAccountService: NewAccountService(url: configuration.newAccountURL, client: URLSessionHTTPClient()),
        addNewUserService: AddNewUserService(url: configuration.newUserURL, client: URLSessionHTTPClient()),
        userLoginService: UserLoginService(url: configuration.userLoginURL, client: URLSessionHTTPClient()),
        userLogoutService: UserLogoutService(url: configuration.userLogoutURL, client: URLSessionHTTPClient())
    )
}
