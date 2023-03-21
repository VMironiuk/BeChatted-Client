//
//  UserLoginInfo.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.03.2023.
//

import Foundation

public struct UserLoginInfo: Codable, Equatable {
    let user: String
    let token: String
    
    public init(user: String, token: String) {
        self.user = user
        self.token = token
    }
}
