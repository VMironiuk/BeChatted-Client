//
//  UserLoginInfo.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 04.03.2023.
//

import Foundation

public struct UserLoginInfo: Decodable {
    let user: String
    let token: String
}
