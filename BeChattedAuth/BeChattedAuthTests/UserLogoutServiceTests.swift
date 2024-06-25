//
//  UserLogoutServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 07.04.2023.
//

import XCTest
@testable import BeChattedAuth

final class UserLogoutServiceTests: XCTestCase {
  
  func test_init_doesNotSendRequestByURL() {
    // given
    let client = HTTPClientSpy()
    let url = anyURL()
    
    // when
    _ = UserLogoutService(url: url, client: client)
    
    // then
    XCTAssertEqual(client.requestedURLs, [])
  }
  
  func test_logout_sendsLogoutRequestByURL() {
    // given
    let url = anyURL()
    let (sut, client) = makeSUT(url: url)
    
    // when
    sut.logout() { _ in }
    
    // then
    XCTAssertEqual(client.requestedURLs, [url])
  }
  
  func test_logout_sendsLogoutRequestByURLTwice() {
    // given
    let url = anyURL()
    let (sut, client) = makeSUT(url: url)
    
    // when
    sut.logout() { _ in }
    sut.logout() { _ in }
    
    // then
    XCTAssertEqual(client.requestedURLs, [url, url])
  }
  
  func test_logout_deliversConnectivityErrorOnClientError() {
    // given
    let (sut, client) = makeSUT()
    
    var receivedError: UserLogoutServiceError?
    let exp = expectation(description: "Wait for completion")
    sut.logout() { result in
      switch result {
      case let .failure(error):
        receivedError = error
        
      default:
        XCTFail("Expected failure, got \(result) instead")
      }
      
      exp.fulfill()
    }
    
    // when
    client.complete(withError: NSError(domain: "any error", code: 0))
    
    wait(for: [exp], timeout: 1.0)
    
    // then
    XCTAssertEqual(receivedError, .connectivity)
  }
  
  func test_logout_deliversSuccessfulResultOnAnyResponse() {
    // given
    let (sut, client) = makeSUT()
    
    var receivedResult: Result<Void, UserLogoutServiceError>?
    sut.logout() { result in
      receivedResult = result
    }
    
    // when
    client.complete()
    
    // then
    XCTAssertNotNil(receivedResult)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    url: URL = URL(string: "http://any-url.com")!,
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (UserLogoutServiceProtocol, HTTPClientSpy) {
    let client = HTTPClientSpy()
    let sut = UserLogoutService(url: url, client: client)
    
    trackForMemoryLeaks(client, file: file, line: line)
    
    return (sut, client)
  }
  
  private class HTTPClientSpy: HTTPClientProtocol {
    private var messages = [Message]()
    
    var requestedURLs: [URL] {
      messages.compactMap { $0.request.url }
    }
    
    private struct Message {
      let request: URLRequest
      let completion: (Result<(Data?, HTTPURLResponse?), Error>) -> Void
    }
    
    func perform(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void) {
      messages.append(Message(request: request, completion: completion))
    }
    
    func complete(withError error: Error, at index: Int = 0) {
      messages[index].completion(.failure(error))
    }
    
    func complete(at index: Int = 0) {
      messages[index].completion(.success((nil, nil)))
    }
  }
}
