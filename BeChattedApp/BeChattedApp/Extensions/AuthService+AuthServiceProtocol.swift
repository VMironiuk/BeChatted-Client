//
//  AuthService+AuthServiceProtocol.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 27.02.2024.
//

import Foundation
import BeChattedAuth
import BeChattediOS

extension AuthService: BeChattediOS.AuthServiceProtocol {
    public func addUser(
        _ payload: BeChattediOS.AddUserPayload,
        authToken: String,
        completion: @escaping (Result<BeChattediOS.AddedUserInfo, BeChattediOS.AuthError>) -> Void
    ) {
    }
    
    public func login(
        _ payload: BeChattediOS.LoginPayload,
        completion: @escaping (Result<BeChattediOS.LoginInfo, BeChattediOS.AuthError>) -> Void
    ) {
    }
    
    public func createAccount(
        _ payload: BeChattediOS.CreateAccountPayload,
        completion: @escaping (Result<Void, BeChattediOS.AuthError>) -> Void
    ) {
    }
}
