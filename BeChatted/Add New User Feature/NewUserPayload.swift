//
//  NewUserPayload.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 30.03.2023.
//

import Foundation

public struct NewUserPayload: Encodable {
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
