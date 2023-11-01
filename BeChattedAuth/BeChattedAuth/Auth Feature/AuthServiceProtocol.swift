//
//  AuthServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 30.10.2023.
//

import Foundation

public protocol AuthServiceProtocol: AnyObject {
    func send(newAccountPayload: NewAccountPayload, completion: @escaping (Result<Void, Error>) -> Void)
    func send(userLoginPayload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, Error>) -> Void)
    func send(newUserPayload: NewUserPayload, completion: @escaping (Result<NewUserInfo, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
}
