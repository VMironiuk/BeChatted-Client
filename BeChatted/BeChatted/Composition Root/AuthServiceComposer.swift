//
//  AuthServiceComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.11.2023.
//

import BeChattedAuth

struct AuthServiceComposer {
    private static let httpProtocol = "http"
    private static let host = "localhost"
    private static let port = "3005"
    private static let baseURLString = "\(httpProtocol)://\(host):\(port)"
    
    private static let createAccountEndpoint = "/v1/account/register"
    private static let userLoginEndpoint = "/v1/account/login"
    private static let addUserEndpoint = "/v1/user/add"
    
    private static let newAccountURL = URL(string: "\(baseURLString)\(createAccountEndpoint)")!
    private static let newUserURL = URL(string: "\(baseURLString)\(addUserEndpoint)")!
    private static let userLoginURL = URL(string: "\(baseURLString)\(userLoginEndpoint)")!
    private static let userLogoutURL = URL(string: "http://dummy-url.com")!
    
    let authService = makeAuthService(
        configuration: AuthServiceConfiguration(
            newAccountURL: newAccountURL,
            newUserURL: newUserURL,
            userLoginURL: userLoginURL,
            userLogoutURL: userLogoutURL
        )
    )
}
