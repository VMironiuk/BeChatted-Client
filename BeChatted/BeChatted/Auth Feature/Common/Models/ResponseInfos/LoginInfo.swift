//
//  LoginInfo.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import Foundation

public struct LoginInfo: Decodable, Equatable {
    public let user: String
    public let token: String
    
    public init(user: String, token: String) {
        self.user = user
        self.token = token
    }
}
