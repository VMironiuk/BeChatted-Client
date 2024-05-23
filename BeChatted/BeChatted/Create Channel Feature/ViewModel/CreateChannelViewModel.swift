//
//  CreateChannelViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.05.2024.
//

import Foundation

public final class CreateChannelViewModel {
    private let service: CreateChannelServiceProtocol
    
    public init(service: CreateChannelServiceProtocol) {
        self.service = service
    }
    
    public func createChannel(withName name: String, description: String) {
    }
}
