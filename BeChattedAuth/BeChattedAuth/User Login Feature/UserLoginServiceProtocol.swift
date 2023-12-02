//
//  UserLoginServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.03.2023.
//

import Foundation

enum UserLoginServiceError: Error {
    case connectivity
    case credentials
    case server
    case invalidData
    case unknown
}

protocol UserLoginServiceProtocol {
    func send(userLoginPayload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, UserLoginServiceError>) -> Void)
}
