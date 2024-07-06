//
//  UserServiceTests.swift
//  UserServiceTests
//
//  Created by Volodymyr Myroniuk on 05.07.2024.
//

import XCTest

public protocol HTTPClientProtocol {
  func perform(
    request: URLRequest,
    completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void
  )
}

public struct UserData {
  public let id: String
  public let name: String
  public let email: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case name
    case email
  }
}

public enum UserServiceError: Error {
  case server
  case connectivity
}

public struct UserService {
  private let url: URL
  private let client: HTTPClientProtocol
  
  public init(url: URL, client: HTTPClientProtocol) {
    self.url = url
    self.client = client
  }
  
  public func user(
    by email: String,
    authToken: String,
    completion: (Result<UserData, UserServiceError>) -> Void
  ) {
    let request = URLRequest(url: url)
    
    client.perform(request: request) { _ in }
  }
}

final class UserServiceTests: XCTestCase {
  func test_init_doesNotSendRequests() {
    let (_, client) = makeSUT()
    
    XCTAssertEqual(client.userByEmailCallCount, 0)
  }
  
  func test_userByEmail_sendsUserByEmailRequest() {
    let (sut, client) = makeSUT()
    
    sut.user(by: "mail@example.com", authToken: "token") { _ in }
    
    XCTAssertEqual(client.userByEmailCallCount, 1)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (UserService, HTTPClientSpy) {
    let url = URL(string: "http://any-url.com")!
    let client = HTTPClientSpy()
    let sut = UserService(url: url, client: client)
    
    trackForMemoryLeaks(client, file: file, line: line)
    
    return (sut, client)
  }
  
  func trackForMemoryLeaks(
    _ object: AnyObject,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    addTeardownBlock { [weak object] in
      XCTAssertNil(
        object,
        "Expected object to be nil. Potential memory leak",
        file: file,
        line: line
      )
    }
  }
  
  private class HTTPClientSpy: HTTPClientProtocol {
    private(set) var userByEmailCallCount = 0
    
    func perform(
      request: URLRequest,
      completion: @escaping (Result<(Data?, HTTPURLResponse?), any Error>) -> Void
    ) {
      userByEmailCallCount += 1
    }
  }
}
