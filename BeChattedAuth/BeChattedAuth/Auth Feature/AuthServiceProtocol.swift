//
//  AuthServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 30.10.2023.
//

import Foundation

public enum AuthServiceError: Error {
    case server
    case connectivity
    case email
    case credentials
    case unknown
}

public protocol AuthServiceProtocol: AnyObject {
    func createAccount(_ payload: NewAccountPayload, completion: @escaping (Result<Void, AuthServiceError>) -> Void)
    func addUser(_ payload: NewUserPayload, authToken: String, completion: @escaping (Result<NewUserInfo, AuthServiceError>) -> Void)
    func login(_ payload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, AuthServiceError>) -> Void)
    func logout(completion: @escaping (Result<Void, AuthServiceError>) -> Void)
}
