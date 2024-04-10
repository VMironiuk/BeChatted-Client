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
    let httpClient: HTTPClientProtocol
    
    public init(newAccountURL: URL, newUserURL: URL, userLoginURL: URL, userLogoutURL: URL, httpClient: HTTPClientProtocol) {
        self.newAccountURL = newAccountURL
        self.newUserURL = newUserURL
        self.userLoginURL = userLoginURL
        self.userLogoutURL = userLogoutURL
        self.httpClient = httpClient
    }
}

public func makeAuthService(configuration: AuthServiceConfiguration) -> AuthService {
    AuthService(
        newAccountService: NewAccountService(url: configuration.newAccountURL, client: configuration.httpClient),
        addNewUserService: AddNewUserService(url: configuration.newUserURL, client: configuration.httpClient),
        userLoginService: UserLoginService(url: configuration.userLoginURL, client: configuration.httpClient),
        userLogoutService: UserLogoutService(url: configuration.userLogoutURL, client: configuration.httpClient)
    )
}
