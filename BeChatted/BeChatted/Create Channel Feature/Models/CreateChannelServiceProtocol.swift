//
//  CreateChannelServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.05.2024.
//

import Foundation

public enum CreateChannelServiceError: Error {
    case server
    case connectivity
    case unknown
}

public protocol CreateChannelServiceProtocol {
    func createChannel(withName name: String, description: String, completion: @escaping (Result<Void, CreateChannelServiceError>) -> Void)
}
