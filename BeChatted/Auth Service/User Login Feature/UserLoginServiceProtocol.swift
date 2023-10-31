//
//  UserLoginServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.03.2023.
//

import Foundation

public protocol UserLoginServiceProtocol {
    func send(userLoginPayload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, Error>) -> Void)
}
