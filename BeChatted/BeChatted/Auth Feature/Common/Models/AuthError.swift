//
//  AuthError.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.12.2023.
//

import Foundation

public enum AuthError: Error {
  case server
  case connectivity
  case email
  case credentials
  case fetchUser
  case unknown
}

extension AuthError {
  var title: String {
    switch self {
    case .server:
      return "Server Unreachable"
    case .connectivity:
      return "Connection Problem"
    case .email:
      return "Email Already in Use"
    case .credentials:
      return "Login Failed"
    case .fetchUser:
      return "Cannot Fetch User Info"
    case .unknown:
      return "Oops! Something Went Wrong"
    }
  }
  
  var description: String {
    switch self {
    case .server:
      return "We're having trouble connecting to our servers right now. Please try again later"
    case .connectivity:
      return "It looks like you're having network issues. "
      + "Please check your internet connection and try again"
    case .email:
      return "This email address is already associated with an account. "
      + "If this account is yours, please log in. Otherwise, use a different email address"
    case .credentials:
      return "The credentials you entered do not match our records. "
      + "Please double-check your details and try again"
    case .fetchUser:
      return "Cannot fetch user info."
    case .unknown:
      return "An unexpected error occurred. Please try again. "
      + "If the problem persists, contact our support team for assistance"
    }
  }
}
