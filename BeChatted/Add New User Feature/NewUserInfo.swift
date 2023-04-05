//
//  NewUserInfo.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 30.03.2023.
//

import Foundation

public struct NewUserInfo: Decodable, Equatable {
    public let name: String
    public let email: String
    public let avatarName: String
    public let avatarColor: String
}
