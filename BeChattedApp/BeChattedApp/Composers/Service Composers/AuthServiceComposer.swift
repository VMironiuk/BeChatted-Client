//
//  AuthServiceComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import BeChatted
import BeChattedAuth
import BeChattedNetwork

struct AuthServiceComposer {
  private init() {}
  
  private static let baseURLString = URLProvider.baseURLString
  
  private static let createAccountEndpoint = "/v1/account/register"
  private static let addUserEndpoint = "/v1/user/add"
  private static let userLoginEndpoint = "/v1/account/login"
  private static let userLogoutEndpoint = "/v1/account/logout"
  
  private static let newAccountURL = URL(string: "\(baseURLString)\(createAccountEndpoint)")!
  private static let newUserURL = URL(string: "\(baseURLString)\(addUserEndpoint)")!
  private static let userLoginURL = URL(string: "\(baseURLString)\(userLoginEndpoint)")!
  private static let userLogoutURL = URL(string: "\(baseURLString)\(userLogoutEndpoint)")!
  
  static let authService = AuthService(
    configuration: AuthServiceConfiguration(
      newAccountURL: newAccountURL,
      newUserURL: newUserURL,
      userLoginURL: userLoginURL,
      userLogoutURL: userLogoutURL,
      httpClient: URLSessionHTTPClient()
    )
  )
}
