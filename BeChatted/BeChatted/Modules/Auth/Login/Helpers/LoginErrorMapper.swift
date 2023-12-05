//
//  LoginErrorMapper.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.12.2023.
//

import Foundation
import BeChattedAuth

public struct LoginErrorMapper {
    private init() {}
    
    public static func error(for error: AuthServiceError) -> LoginViewModel.Error {
        switch error {
        case .server:
            return LoginViewModel.Error(
                title: "Server Unreachable",
                description: "We're having trouble connecting to our servers right now. Please try again later"
            )
        case .connectivity:
            return LoginViewModel.Error(
                title: "Connection Problem",
                description: "It looks like you're having network issues. "
                    + "Please check your internet connection and try again"
            )
        case .credentials:
            return LoginViewModel.Error(
                title: "Login Failed",
                description: "The credentials you entered do not match our records. "
                    + "Please double-check your details and try again"
            )
        case .email, .unknown:
            return LoginViewModel.Error(
                title: "Oops! Something Went Wrong",
                description: "An unexpected error occurred. Please try again. "
                    + "If the problem persists, contact our support team for assistance"
            )
        }
    }
}

