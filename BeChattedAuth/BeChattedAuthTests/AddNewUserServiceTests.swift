//
//  AddNewUserServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 28.03.2023.
//

import XCTest
@testable import BeChattedAuth

final class AddNewUserServiceTests: XCTestCase {
  
  func test_init_doesNotSendNewUserRequestByURL() {
    // given
    // when
    let (_, client) = makeSUT(url: anyURL())
    
    // then
    XCTAssertEqual(client.requestedURLs, [])
  }
  
  func test_send_sendNewUserPayloadRequestByURL() {
    // given
    let url = anyURL()
    let (sut, client) = makeSUT(url: url)
    
    // when
    sut.send(newUserPayload: anyNewUserPayload(), authToken: "auth token") { _ in }
    
    // then
    XCTAssertEqual(client.requestedURLs, [url])
  }
  
  func test_send_sendsNewUserPayloadRequestByURLTwice() {
    // given
    let url = anyURL()
    let (sut, client) = makeSUT(url: url)
    
    // when
    sut.send(newUserPayload: anyNewUserPayload(), authToken: "auth token") { _ in }
    sut.send(newUserPayload: anyNewUserPayload(), authToken: "auth token") { _ in }
    
    // then
    XCTAssertEqual(client.requestedURLs, [url, url])
  }
  
  func test_send_sendsNewUserRequestAsPOSTMethod() {
    // given
    let url = anyURL()
    let (sut, client) = makeSUT(url: url)
    
    // when
    sut.send(newUserPayload: anyNewUserPayload(), authToken: "auth token") { _ in }
    
    // then
    XCTAssertEqual(client.httpMethods, ["POST"])
  }
  
  func test_send_sendsNewUserRequestAsApplicationJSONContentType() {
    // given
    let url = anyURL()
    let (sut, client) = makeSUT(url: url)
    
    // when
    sut.send(newUserPayload: anyNewUserPayload(), authToken: "auth token") { _ in }
    
    // then
    XCTAssertEqual(client.contentTypes, ["application/json"])
  }
  
  func test_send_sendsNewUserRequestWithAuthToken() {
    // given
    let url = anyURL()
    let (sut, client) = makeSUT(url: url)
    let authToken = "auth token to check..."
    
    // when
    sut.send(newUserPayload: anyNewUserPayload(), authToken: authToken) { _ in }
    
    // then
    XCTAssertEqual(client.authTokens, ["Bearer \(authToken)"])
  }
  
  func test_send_sendsNewUserPayload() {
    // given
    let url = anyURL()
    let (sut, client) = makeSUT(url: url)
    let newUserPayload = NewUserPayload(name: "a name", email: "email@example.com", avatarName: "", avatarColor: "")
    
    // when
    sut.send(newUserPayload: newUserPayload, authToken: "auth token") { _ in }
    
    // then
    XCTAssertEqual(client.newUserPayloads, [newUserPayload])
  }
  
  func test_send_deliversConnectivityErrorOnClientError() {
    let (sut, client) = makeSUT()
    
    expect(sut: sut, toCompleteWithError: .connectivity, when: {
      client.complete(withError: anyNSError())
    })
  }
  
  func test_send_deliversServerErrorOn500HTTPResponse() {
    let (sut, client) = makeSUT()
    
    expect(sut: sut, toCompleteWithError: .server, when: {
      client.completeWith(response: httpResponse(withStatusCode: 500))
    })
  }
  
  func test_send_deliversUnknownErrorOnNon200HTTPResponse() {
    let (sut, client) = makeSUT()
    
    let samples = [100, 199, 201, 300, 400, 599]
    samples.enumerated().forEach { index, code in
      expect(sut: sut, toCompleteWithError: .unknown, when: {
        client.completeWith(response: httpResponse(withStatusCode: code), at: index)
      })
    }
  }
  
  func test_send_deliversInvalidDataErrorOn200HTTPResponseWithInvalidBody() {
    let (sut, client) = makeSUT()
    
    expect(sut: sut, toCompleteWithError: .invalidData, when: {
      client.completeWith(data: anyData(), response: httpResponse(withStatusCode: 200))
    })
  }
  
  func test_send_deliversNewUserInfoOn200HTTPResponseWithValidBody() {
    // given
    let (sut, client) = makeSUT()
    
    let expectedNewUserInfoData = """
        {
            "name": "new user",
            "email": "new-user@example.com",
            "avatarName": "avatarName",
            "avatarColor": "avatarColor"
        }
        """.data(using: .utf8)
    let expectedNewUserInfo = try! JSONDecoder().decode(NewUserInfo.self, from: expectedNewUserInfoData!)
    
    expect(sut: sut, toCompleteWithNewUserInfo: expectedNewUserInfo, when: {
      client.completeWith(data: expectedNewUserInfoData, response: httpResponse(withStatusCode: 200))
    })
  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    url: URL = URL(string: "http://any-url.com")!,
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (AddNewUserServiceProtocol, HTTPClientSpy) {
    let client = HTTPClientSpy()
    let sut = AddNewUserService(url: url, client: client)
    
    trackForMemoryLeaks(client, file: file, line: line)
    
    return (sut, client)
  }
  
  private func expect(
    sut: AddNewUserServiceProtocol,
    toCompleteWithError expectedError: AddNewUserServiceError,
    when action: () -> Void,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    // given
    let exp = expectation(description: "Wait for completion")
    var receivedError: AddNewUserServiceError?
    
    sut.send(newUserPayload: anyNewUserPayload(), authToken: "auth token") { result in
      switch result {
      case let .failure(error):
        receivedError = error
        
      default:
        XCTFail("Expected failure, got \(result) instead.", file: file, line: line)
      }
      
      exp.fulfill()
    }
    
    // when
    action()
    
    wait(for: [exp], timeout: 1.0)
    
    // then
    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
  }
  
  private func expect(
    sut: AddNewUserServiceProtocol,
    toCompleteWithNewUserInfo expectedNewUserInfo: NewUserInfo,
    when action: () -> Void,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    // given
    let exp = expectation(description: "Wait for completion")
    var receivedNewUserInfo: NewUserInfo?
    
    sut.send(newUserPayload: anyNewUserPayload(), authToken: "auth token") { result in
      switch result {
      case let .success(newUserInfo):
        receivedNewUserInfo = newUserInfo
        
      default:
        XCTFail("Expected new user info, got \(result) instead", file: file, line: line)
      }
      
      exp.fulfill()
    }
    
    // when
    action()
    
    wait(for: [exp], timeout: 1.0)
    
    // then
    XCTAssertEqual(receivedNewUserInfo, expectedNewUserInfo, file: file, line: line)
    
  }
  
  private class HTTPClientSpy: HTTPClientProtocol {
    private var messages = [Message]()
    
    var requestedURLs: [URL] {
      messages.compactMap { $0.request.url }
    }
    
    var httpMethods: [String] {
      messages.compactMap { $0.request.httpMethod }
    }
    
    var contentTypes: [String] {
      messages.compactMap { $0.request.value(forHTTPHeaderField: "Content-Type") }
    }
    
    var authTokens: [String] {
      messages.compactMap { $0.request.value(forHTTPHeaderField: "Authorization") }
    }
    
    var newUserPayloads: [NewUserPayload] {
      messages.compactMap {
        guard let data = $0.request.httpBody else { return nil }
        return try? JSONDecoder().decode(NewUserPayload.self, from: data)
      }
    }
    
    private struct Message {
      let request:  URLRequest
      let completion: (Result<(Data?, HTTPURLResponse?), Error>) -> Void
      
      init(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void) {
        self.request = request
        self.completion = completion
      }
    }
    
    func perform(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void) {
      messages.append(Message(request: request, completion: completion))
    }
    
    func complete(withError error: Error, at index: Int = 0) {
      messages[index].completion(.failure(error))
    }
    
    func completeWith(data: Data? = nil, response: HTTPURLResponse, at index: Int = 0) {
      messages[index].completion(.success((data, response)))
    }
  }
}
