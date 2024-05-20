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

public enum ChannelsServiceError: Error {
    case unknown
    case connectivity
    case invalidData
}

public protocol ChannelsServiceProtocol {
    func loadChannels(completion: @escaping (Result<[Channel], ChannelsServiceError>) -> Void)
    func createChannel(withName name: String, description: String, completion: @escaping (Result<Void, ChannelsServiceError>) -> Void)
}
