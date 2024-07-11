//
//  UserServiceTests.swift
//  UserServiceTests
//
//  Created by Volodymyr Myroniuk on 05.07.2024.
//

import XCTest
import BeChattedUser

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
  
  func test_userByEmail_receivesUserDataOnSuccessfulCompletion() {
    let (sut, client) = makeSUT()
    let expectedUserData = UserData(id: "user-id", name: "user-name", email: "user@example.com")
    let exp = expectation(description: "Wait for receiving user data completion")
    
    sut.user(
      by: expectedUserData.email,
      authToken: "any-token") { result in
        if case let .success(receivedUserData) = result {
          XCTAssertEqual(expectedUserData, receivedUserData)
        } else {
          XCTFail("Expected \(expectedUserData), got \(result) instead")
        }
        exp.fulfill()
      }
    
    client.complete(with: try? JSONEncoder().encode(expectedUserData))
    wait(for: [exp], timeout: 1)
  }
  
  func test_userByEmail_receivesConnectivityErrorOnNon200HTTPResponse() {
    let (sut, client) = makeSUT()
    let anyUserData = UserData(id: "user-id", name: "user-name", email: "user@example.com")
    let exp = expectation(description: "Wait for receiving user data completion")
    
    sut.user(
      by: anyUserData.email,
      authToken: "any-token") { result in
        if case let .failure(receivedError) = result {
          XCTAssertEqual(receivedError, .connectivity)
        } else {
          XCTFail("Expected connectivity error, got \(result) instead")
        }
        exp.fulfill()
      }
    
    client.complete(with: try? JSONEncoder().encode(anyUserData), statusCode: 500)
    wait(for: [exp], timeout: 1)
  }

  func test_userByEmail_receivesInvalidDataErrorOnInvalidDataInResponse() {
    let (sut, client) = makeSUT()
    let exp = expectation(description: "Wait for receiving user data completion")
    
    sut.user(
      by: "user@example.com",
      authToken: "any-token") { result in
        if case let .failure(receivedError) = result {
          XCTAssertEqual(receivedError, .invalidData)
        } else {
          XCTFail("Expected connectivity error, got \(result) instead")
        }
        exp.fulfill()
      }
    
    client.complete(with: "invalid data".data(using: .utf8))
    wait(for: [exp], timeout: 1)
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
    private var completions = [(Result<(Data?, HTTPURLResponse?), any Error>) -> Void]()
    private(set) var userByEmailCallCount = 0
    
    func perform(
      request: URLRequest,
      completion: @escaping (Result<(Data?, HTTPURLResponse?), any Error>) -> Void
    ) {
      userByEmailCallCount += 1
      completions.append(completion)
    }
    
    func complete(with data: Data?, statusCode: Int = 200, at index: Int = 0) {
      let url = URL(string: "http://any-url.com")!
      let response = HTTPURLResponse(
        url: url,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil
      )
      completions[index](.success((data, response)))
    }
  }
}

extension UserData: Equatable {
  public static func == (lhs: UserData, rhs: UserData) -> Bool {
    lhs.id == rhs.id && lhs.name == rhs.name && lhs.email == rhs.email
  }
}
