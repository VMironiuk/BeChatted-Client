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
}
