//
//  RegisterErrorMapper.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.12.2023.
//

import Foundation
import BeChattedAuth

public struct RegisterErrorMapper {
    private init() {}
    
    public static func error(for error: AuthServiceError) -> RegisterViewModel.Error {
        switch error {
        case .server:
            return RegisterViewModel.Error(
                title: "Server Unreachable",
                description: "We're having trouble connecting to our servers right now. Please try again later"
            )
        case .connectivity:
            return RegisterViewModel.Error(
                title: "Connection Problem",
                description: "It looks like you're having network issues. "
                    + "Please check your internet connection and try again"
            )
        case .email:
            return RegisterViewModel.Error(
                title: "Email Already in Use",
                description: "This email address is already associated with an account. "
                    + "If this account is yours, please log in. Otherwise, use a different email address"
            )
        case .credentials, .unknown:
            return RegisterViewModel.Error(
                title: "Oops! Something Went Wrong",
                description: "An unexpected error occurred. Please try again. "
                    + "If the problem persists, contact our support team for assistance"
            )
        }
    }
}
