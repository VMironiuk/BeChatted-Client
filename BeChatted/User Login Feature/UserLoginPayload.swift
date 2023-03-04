//
//  UserLoginPayload.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.03.2023.
//

import Foundation

struct UserLoginPayload: Encodable {
    let user: String
    let password: String
}
