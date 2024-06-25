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
  
  public init(service: AuthServiceProtocol) {
    self.service = service
  }
}

final class LogoutViewModelTests: XCTestCase {
  func test_init_doesNotSendLogoutRequest() {
    let (_, service) = makeSUT()
    
    XCTAssertEqual(service.logoutCallCount, 0)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (LogoutViewModel, AuthServiceStub) {
    let service = AuthServiceStub()
    let sut = LogoutViewModel(service: service)
    
    trackForMemoryLeaks(sut, file: file, line: line)
    
    return (sut, service)
  }
}
