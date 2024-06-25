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
  
  public init(service: AuthServiceProtocol, authToken: String) {
    self.service = service
    self.authToken = authToken
  }
  
  public func logout() {
    service.logout(authToken: authToken) { _ in
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
  
  // MARK: - Helpers
  
  private func makeSUT(
    authToken: String = "any-auth-token",
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (LogoutViewModel, AuthServiceStub) {
    let service = AuthServiceStub()
    let sut = LogoutViewModel(service: service, authToken: authToken)
    
    trackForMemoryLeaks(sut, file: file, line: line)
    
    return (sut, service)
  }
}
