//
//  NewUserPayload+Decodable.swift
//  BeChattedAuthTests
//
//  Created by Volodymyr Myroniuk on 02.12.2023.
//

import Foundation
import BeChattedAuth

extension NewUserPayload: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case email
        case avatarName
        case avatarColor
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let email = try container.decode(String.self, forKey: .email)
        let avatarName = try container.decode(String.self, forKey: .avatarName)
        let avatarColor = try container.decode(String.self, forKey: .avatarColor)
        
        self.init(name: name, email: email, avatarName: avatarName, avatarColor: avatarColor)
    }
}
