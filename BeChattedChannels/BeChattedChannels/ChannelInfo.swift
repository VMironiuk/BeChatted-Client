//
//  ChannelInfo.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 09.04.2024.
//

import Foundation

public struct ChannelInfo: Codable, Equatable {
    let id: String
    let name: String
    let description: String
    
    public init(id: String, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
    }
}
