//
//  NewAccountPayload.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 17.02.2023.
//

import Foundation

public struct NewAccountPayload: Encodable, Equatable {
    private let email: String
    private let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
