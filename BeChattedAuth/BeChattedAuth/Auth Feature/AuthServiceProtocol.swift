//
//  AuthServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 30.10.2023.
//

import Foundation

public protocol AuthServiceProtocol: AnyObject {
    func createAccount(_ payload: NewAccountPayload, completion: @escaping (Result<Void, Error>) -> Void)
    func addUser(_ payload: NewUserPayload, authToken: String, completion: @escaping (Result<NewUserInfo, Error>) -> Void)
    func login(_ payload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
}
