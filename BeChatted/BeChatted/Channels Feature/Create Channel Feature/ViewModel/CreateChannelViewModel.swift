//
//  CreateChannelViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.05.2024.
//

import Foundation

public enum CreateChannelViewModelState: Equatable {
  case ready
  case inProgress
  case failure(CreateChannelServiceError)
  case success
}

public final class CreateChannelViewModel: ObservableObject {
  private let service: CreateChannelServiceProtocol_WebSocket
  private let animator: AnimatorProtocol
  private let onSuccess: () -> Void
  
  @Published public private(set) var state: CreateChannelViewModelState = .ready
  @Published public var channelName = ""
  @Published public var channelDescription = ""
  public var isUserInputValid: Bool {
    !channelName.isEmpty && !channelDescription.isEmpty
  }
  
  public init(
    service: CreateChannelServiceProtocol_WebSocket,
    animator: AnimatorProtocol = ViewModelAnimator(),
    onSuccess: @escaping () -> Void = {}
  ) {
    self.service = service
    self.animator = animator
    self.onSuccess = onSuccess
  }
  
  public func createChannel() {
    state = .inProgress
    
    let channelNameValidated = self.channelName
      .trimmingCharacters(in: CharacterSet(charactersIn: " "))
      .lowercased()
      .replacingOccurrences(of: " ", with: "-")
    
    service.addChannel(withName: channelNameValidated, description: channelDescription)
    updateStateWithAnimation(to: .success)
    channelName = ""
    channelDescription = ""
    onSuccess()
  }
  
  private func updateStateWithAnimation(to newState: CreateChannelViewModelState) {
    animator.perform {
      state = newState
    } completion: { [weak self] in
      self?.state = .ready
    }
  }
}
