//
//  ProfileViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 26.06.2024.
//

import Foundation

public final class ProfileViewModel: ObservableObject {
  public enum State: Equatable {
    case idle
    case inProgress
    case success
    case failure(Error)
  }
  
  private let service: AuthServiceProtocol
  private let authToken: String
  private let onLogoutAction: () -> Void
  
  @Published public var state = State.idle
  
  public init(
    service: AuthServiceProtocol,
    authToken: String,
    onLogoutAction: @escaping () -> Void
  ) {
    self.service = service
    self.authToken = authToken
    self.onLogoutAction = onLogoutAction
  }
  
  public func logout() {
    state = .inProgress
    service.logout(authToken: authToken) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success: self?.state = .success
        case .failure(let error): self?.state = .failure(error)
        }
        self?.onLogoutAction()
      }
    }
  }
}

public extension ProfileViewModel.State {
  static func == (lhs: ProfileViewModel.State, rhs: ProfileViewModel.State) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle): true
    case (.inProgress, .inProgress): true
    case (.success, .success): true
    case (.failure(let lhsError), .failure(let rhsError)):
      lhsError.localizedDescription == rhsError.localizedDescription
    default: false
    }
  }
}
