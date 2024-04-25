//
//  ChannelsViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 25.04.2024.
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

public protocol ChannelsLoaderProtocol {
    func load(completion: @escaping (Result<[Channel], LoadChannelsError>) -> Void)
}

public enum ChannelItem: Identifiable {
    public var id: UUID { UUID() }
    case title
    case channel(name: String, isUnread: Bool)
}

@Observable public final class ChannelsViewModel {
    private let loader: ChannelsLoaderProtocol
    
    public var loadChannelsResult: Result<[ChannelItem], LoadChannelsError> = .success([])
    
    public init(loader: ChannelsLoaderProtocol) {
        self.loader = loader
    }
    
    public func loadChannels() {
        loader.load { [weak self] result in
            self?.loadChannelsResult = ChannelsViewModelResultMapper.map(from: result)
        }
    }
}

struct ChannelsViewModelResultMapper {
    private init() {}
    
    static func map(from result: Result<[Channel], LoadChannelsError>) -> Result<[ChannelItem], LoadChannelsError> {
        switch result {
        case .success(let channels):
            guard !channels.isEmpty else { return .success([]) }
            return .success([.title] + channels.map { .channel(name: $0.name, isUnread: false) })
        case .failure(let error):
            return .failure(error)
        }
    }
}
