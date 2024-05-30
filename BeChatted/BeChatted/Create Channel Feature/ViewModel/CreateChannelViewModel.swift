//
//  CreateChannelViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.05.2024.
//

import SwiftUI

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
                self.updateStateWithAnimation(to: .success)
            case .failure(let error):
                self.updateStateWithAnimation(to: .failure(error))
            }
        }
    }
    
    private func updateStateWithAnimation(to newState: CreateChannelViewModelState) {
        withAnimation {
            state = newState
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            withAnimation {
                self?.state = .ready
            }
        }
    }
}
