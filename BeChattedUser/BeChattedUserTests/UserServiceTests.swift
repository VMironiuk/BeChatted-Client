//
//  UserServiceTests.swift
//  UserServiceTests
//
//  Created by Volodymyr Myroniuk on 05.07.2024.
//

import XCTest

protocol HTTPClientProtocol {}

public struct UserService {
  let client: HTTPClientProtocol
}

final class UserServiceTests: XCTestCase {
  func test_init_doesNotSendRequests() {
    let client = HTTPClientSpy()
    let _ = UserService(client: client)
    
    XCTAssertEqual(client.userByEmailCallCount, 0)
  }
  
  // MARK: - Helpers
  
  private struct HTTPClientSpy: HTTPClientProtocol {
    private(set) var userByEmailCallCount = 0
  }
}
