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

public struct UserData: Codable {
  public let id: String
  public let name: String
  public let email: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case name
    case email
  }
  
  public init(id: String, name: String, email: String) {
    self.id = id
    self.name = name
    self.email = email
  }
}

public enum UserServiceError: Error {
  case connectivity
  case invalidData
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
    completion: @escaping (Result<UserData, UserServiceError>) -> Void
  ) {
    let request = URLRequest(url: url)
    
    client.perform(request: request) { result in
      switch result {
      case let .success((data, response)):
        guard response?.statusCode == 200 else {
          completion(.failure(.connectivity))
          return
        }
        guard let data = data, let user = try? JSONDecoder().decode(UserData.self, from: data) else {
          completion(.failure(.invalidData))
          return
        }
        completion(.success(user))
        
      case .failure:
        completion(.failure(.connectivity))
      }
    }
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

extension UserData: Equatable {}
