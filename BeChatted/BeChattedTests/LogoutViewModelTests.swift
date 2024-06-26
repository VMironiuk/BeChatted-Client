//
//  LogoutViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 25.06.2024.
//

import XCTest
import BeChatted

public final class LogoutViewModel: ObservableObject {
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
      switch result {
      case .success: self?.state = .success
      case .failure(let error): self?.state = .failure(error)
      }
      self?.onLogoutAction()
    }
  }
}

public extension LogoutViewModel.State {
  static func == (lhs: LogoutViewModel.State, rhs: LogoutViewModel.State) -> Bool {
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

final class LogoutViewModelTests: XCTestCase {
  func test_init_doesNotSendLogoutRequest() {
    let (_, service) = makeSUT()
    
    XCTAssertEqual(service.logoutCallCount, 0)
  }
  
  func test_logout_sendsLogoutRequest() {
    let (sut, service) = makeSUT()
    
    sut.logout()
    
    XCTAssertEqual(service.logoutCallCount, 1)
  }
  
  func test_logout_sendsLogoutRequestTwice() {
    let (sut, service) = makeSUT()
    
    sut.logout()
    sut.logout()
    
    XCTAssertEqual(service.logoutCallCount, 2)
  }
  
  func test_logout_doesNotCallOnLogoutActionWhenLogoutRequestDoesNotComplete() {
    var onLogoutActionCallCount = 0
    let (sut, _) = makeSUT(onLogoutAction: {
      onLogoutActionCallCount += 1
    })
    
    sut.logout()
    
    XCTAssertEqual(onLogoutActionCallCount, 0)
  }
  
  func test_logout_callsOnLogoutActionWhenLogoutRequestCompletedSuccessfully() {
    var onLogoutActionCallCount = 0
    let (sut, service) = makeSUT(onLogoutAction: {
      onLogoutActionCallCount += 1
    })
    
    sut.logout()
    service.completeLogoutSuccessfully()
    
    XCTAssertEqual(onLogoutActionCallCount, 1)
  }
  
  func test_logout_callsOnLogoutActionWhenLogoutRequestFails() {
    var onLogoutActionCallCount = 0
    let (sut, service) = makeSUT(onLogoutAction: {
      onLogoutActionCallCount += 1
    })
    
    sut.logout()
    service.completeLogoutWithError(anyNSError())
    
    XCTAssertEqual(onLogoutActionCallCount, 1)
  }
  
  func test_statesWithSuccessfulLogoutRequest() {
    let (sut, service) = makeSUT()
    XCTAssertEqual(sut.state, .idle)
    
    sut.logout()
    XCTAssertEqual(sut.state, .inProgress)
    
    service.completeLogoutSuccessfully()
    XCTAssertEqual(sut.state, .success)
  }
  
  func test_statesWithFailedLogoutRequest() {
    let (sut, service) = makeSUT()
    XCTAssertEqual(sut.state, .idle)
    
    sut.logout()
    XCTAssertEqual(sut.state, .inProgress)
    
    let error = NSError(domain: "any domain", code: 42)
    service.completeLogoutWithError(error)
    if case let .failure(gotError) = sut.state {
      XCTAssertEqual(error.domain, (gotError as NSError).domain)
      XCTAssertEqual(error.code, (gotError as NSError).code)
    } else {
      XCTFail("Expected failure state, got \(sut.state) instead")
    }
  }

  // MARK: - Helpers
  
  private func makeSUT(
    authToken: String = "any-auth-token",
    onLogoutAction: @escaping () -> Void = {},
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (LogoutViewModel, AuthServiceStub) {
    let service = AuthServiceStub()
    let sut = LogoutViewModel(service: service, authToken: authToken, onLogoutAction: onLogoutAction)
    
    trackForMemoryLeaks(sut, file: file, line: line)
    
    return (sut, service)
  }
  
  private func anyNSError() -> NSError {
    NSError(domain: "any error", code: 1)
  }
}
