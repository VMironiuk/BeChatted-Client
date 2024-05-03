//
//  AuthServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import Foundation

public protocol AuthServiceProtocol {
    func login(_ payload: LoginPayload, completion: @escaping (Result<LoginInfo, AuthError>) -> Void)
    func createAccount(_ payload: CreateAccountPayload, completion: @escaping (Result<Void, AuthError>) -> Void)
    func addUser(_ payload: AddUserPayload, authToken: String, completion: @escaping (Result<AddedUserInfo, AuthError>) -> Void)
}
