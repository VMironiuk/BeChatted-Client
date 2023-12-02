//
//  AddNewUserServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.03.2023.
//

import Foundation

enum AddNewUserServiceError: Error {
    case connectivity
    case server
    case unknown
    case invalidData
}

protocol AddNewUserServiceProtocol {
    func send(
        newUserPayload: NewUserPayload,
        authToken: String,
        completion: @escaping (Result<NewUserInfo, AddNewUserServiceError>) -> Void
    )
}
