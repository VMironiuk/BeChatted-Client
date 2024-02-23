//
//  AddUserPayload.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import Foundation

public struct AddUserPayload: Encodable, Equatable {
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
