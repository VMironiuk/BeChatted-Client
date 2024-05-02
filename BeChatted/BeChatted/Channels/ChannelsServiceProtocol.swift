//
//  ChannelsServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 01.05.2024.
//

import Foundation

public struct Channel {
    public let id: String
    public let name: String
    public let description: String
    
    public init(id: String, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}

public enum LoadChannelsError: Error {
    case unknown
    case connectivity
    case invalidData
}

public protocol ChannelsServiceProtocol {
    func load(completion: @escaping (Result<[Channel], LoadChannelsError>) -> Void)
}
