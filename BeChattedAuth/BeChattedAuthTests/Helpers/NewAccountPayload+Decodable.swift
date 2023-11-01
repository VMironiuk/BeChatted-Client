//
//  NewAccountPayload+Decodable.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 04.03.2023.
//

import Foundation
import BeChattedAuth

extension NewAccountPayload: Decodable {
    private enum CodingKeys: String, CodingKey {
        case email
        case password
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let email = try container.decode(String.self, forKey: .email)
        let password = try container.decode(String.self, forKey: .password)
        
        self.init(email: email, password: password)
    }
}
