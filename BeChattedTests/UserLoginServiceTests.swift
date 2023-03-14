//
//  UserLoginServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 06.03.2023.
//

import XCTest
import BeChatted

protocol HTTPClient {
    func perform(request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}

final class UserLoginService {
    private let url: URL
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case connectivity
        case credentials
        case server
        case unknown
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func send(userLoginPayload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(userLoginPayload)
        
        client.perform(request: request) { _, _, _ in
            completion(.failure(.connectivity))
        }
    }
}

final class UserLoginServiceTests: XCTestCase {
    
    func test_init_doesNotSendUserLoginPayloadByURL() {
        // given
        let client = HTTPClientSpy()
        
        // when
        _ = UserLoginService(url: anyURL(), client: client)
        
        // then
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_send_sendsUserLoginPayloadByURL() {
        // given
        let url = anyURL()
        let client = HTTPClientSpy()
        let sut = UserLoginService(url: url, client: client)
        
        let userLoginPayload = UserLoginPayload(email: "my@example.com", password: "123456")
        
        // when
        sut.send(userLoginPayload: userLoginPayload) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_send_sendsUserLoginPayloadByURLTwice() {
        // given
        let url = anyURL()
        let client = HTTPClientSpy()
        let sut = UserLoginService(url: url, client: client)
        
        let userLoginPayload = UserLoginPayload(email: "my@example.com", password: "123456")
        
        // when
        sut.send(userLoginPayload: userLoginPayload) { _ in }
        sut.send(userLoginPayload: userLoginPayload) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_send_deliversConnectivityErrorOnClientError() {
        // given
        let (sut, client) = makeSUT()
        let userLoginPayload = UserLoginPayload(email: "my@example.com", password: "123456")
        
        let exp = expectation(description: "Wait for completion")
        
        // when
        var receivedError: UserLoginService.Error?
        sut.send(userLoginPayload: userLoginPayload) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected connectivity error, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        client.complete(withError: NSError(domain: "any error", code: 1))
        
        wait(for: [exp], timeout: 1.0)
        
        // then
        XCTAssertEqual(receivedError, .connectivity)
    }
    
    // 5. send() delivers invalid credentials error on 401 HTTP response
    // 6. send() delivers server error on 500...599 HTTP response
    // 7. send() delivers unknown error on non 200, 401 and 500...599 HTTP responses
    // 8. send() delivers invalid data error on 200 HTTP response with invalid responses body
    // 9. send() does not deliver error after instance has been deallocated
    // 10. send() does not deliver error on non 200 HTTP response after instance has been deallocated
    // 11. send() does not deliver user(name) and token on 200 HTTP response after instance has been deallocated
    // 10. send() delivers user(name) and token on 200 HTTP response
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (UserLoginService, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = UserLoginService(url: url, client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private final class HTTPClientSpy: HTTPClient {
        private var messages = [Message]()
        
        private struct Message {
            let url: URL
            let completion: (Data?, HTTPURLResponse?, Error?) -> Void
        }
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func perform(request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
            if let requestedUrl = request.url {
                messages.append(Message(url: requestedUrl, completion: completion))
            }
        }
        
        func complete(withError error: Error, at index: Int = 0) {
            messages[index].completion(nil, nil, error)
        }
    }
}
