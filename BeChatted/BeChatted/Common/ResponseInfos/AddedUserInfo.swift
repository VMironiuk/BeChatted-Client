//
//  AddUserInfo.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import Foundation

public struct AddedUserInfo: Decodable, Equatable {
    public let name: String
    public let email: String
    public let avatarName: String
    public let avatarColor: String
    
    public init(name: String, email: String, avatarName: String, avatarColor: String) {
        self.name = name
        self.email = email
        self.avatarName = avatarName
        self.avatarColor = avatarColor
    }
}
