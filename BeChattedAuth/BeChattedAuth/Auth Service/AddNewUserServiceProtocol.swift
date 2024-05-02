//
//  AddNewUserServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.03.2023.
//

import Foundation

public struct NewUserPayload: Encodable, Equatable {
    private let name: String
    private let email: String
    private let avatarName: String
    private let avatarColor: String
    
    public init(name: String, email: String, avatarName: String, avatarColor: String) {
        self.name = name
        self.email = email
        self.avatarName = avatarName
        self.avatarColor = avatarColor
    }
}

public struct NewUserInfo: Decodable, Equatable {
    public let name: String
    public let email: String
    public let avatarName: String
    public let avatarColor: String
}

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
