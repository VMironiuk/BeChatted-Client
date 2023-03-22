//
//  UserLoginPayload.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.03.2023.
//

import Foundation

public struct UserLoginPayload: Encodable {
    private let email: String
    private let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
