//
//  CreateChannelViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.05.2024.
//

import SwiftUI

public enum CreateChannelViewModelState: Equatable {
    case ready
    case inProgress
    case failure(CreateChannelServiceError)
    case success
}

@Observable public final class CreateChannelViewModel {
    private let service: CreateChannelServiceProtocol
    private let animator: AnimatorProtocol
    private let onSuccess: () -> Void
    
    public private(set) var state: CreateChannelViewModelState = .ready
    public var channelName = ""
    public var channelDescription = ""
    public var isUserInputValid: Bool {
        !channelName.isEmpty && !channelDescription.isEmpty
    }
    
    public init(
        service: CreateChannelServiceProtocol,
        animator: AnimatorProtocol = ViewModelAnimator(),
        onSuccess: @escaping () -> Void = {}
    ) {
        self.service = service
        self.animator = animator
        self.onSuccess = onSuccess
    }
    
    public func createChannel() {
        state = .inProgress
        service.createChannel(withName: channelName, description: channelDescription) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.updateStateWithAnimation(to: .success)
                channelName = ""
                channelDescription = ""
                onSuccess()
            case .failure(let error):
                self.updateStateWithAnimation(to: .failure(error))
            }
        }
    }
    
    private func updateStateWithAnimation(to newState: CreateChannelViewModelState) {
        animator.perform {
            state = newState
        } completion: { [weak self] in
            self?.state = .ready
        }
    }
}
