//
//  CreateChannelViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.05.2024.
//

import Foundation

public enum CreateChannelViewModelState {
    case ready
    case inProgress
    case failure(CreateChannelServiceError)
    case success
}

@Observable public final class CreateChannelViewModel {
    private let service: CreateChannelServiceProtocol
    
    public private(set) var state: CreateChannelViewModelState = .ready
    public var channelName = ""
    public var channelDescription = ""
    public var isUserInputValid: Bool {
        !channelName.isEmpty && !channelDescription.isEmpty
    }
    
    public init(service: CreateChannelServiceProtocol) {
        self.service = service
    }
    
    public func createChannel() {
        state = .inProgress
        service.createChannel(withName: channelName, description: channelDescription) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                state = .success
            case .failure(let error):
                state = .failure(error)
            }
        }
    }
}
