//
//  LogoutViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 25.06.2024.
//

import XCTest
import BeChatted

public final class LogoutViewModel: ObservableObject {
  private let service: AuthServiceProtocol
  private let authToken: String
  private let onLogoutAction: () -> Void
  
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
    service.logout(authToken: authToken) { [weak self] _ in
      self?.onLogoutAction()
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
}
