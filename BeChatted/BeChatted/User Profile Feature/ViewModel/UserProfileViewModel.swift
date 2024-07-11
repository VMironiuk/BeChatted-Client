//
//  UserProfileViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 26.06.2024.
//

import Foundation

public final class UserProfileViewModel: ObservableObject {
  public enum State: Equatable {
    case idle
    case inProgress
    case success
    case failure(Error)
  }
  
  private let info: UserProfileInfo
  private let service: AuthServiceProtocol
  private let authToken: String
  private let onLogoutAction: () -> Void
  
  @Published public var state = State.idle
  public var userName: String { info.name }
  public var userEmail: String { info.email }
  
  public init(
    info: UserProfileInfo,
    service: AuthServiceProtocol,
    authToken: String,
    onLogoutAction: @escaping () -> Void
  ) {
    self.info = info
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

public extension UserProfileViewModel.State {
  static func == (lhs: UserProfileViewModel.State, rhs: UserProfileViewModel.State) -> Bool {
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
