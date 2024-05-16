//
//  CreateChannelPayload+Decodable.swift
//  BeChattedChannelsTests
//
//  Created by Volodymyr Myroniuk on 16.05.2024.
//

import BeChattedChannels

extension CreateChanelPayload: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case description
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        
        self.init(name: name, description: description)
    }
}

