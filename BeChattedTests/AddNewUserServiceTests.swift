//
//  AddNewUserServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 28.03.2023.
//

import XCTest
import BeChatted

class AddNewUserService {
    private let url: URL
    private let client: HTTPClientProtocol
    
    enum AddNewUserError: Swift.Error {
        case connectivity
    }
    
    typealias Error = AddNewUserError
    
    init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    func send(newUserPayload: NewUserPayload, completion: @escaping (Result<NewUserInfo, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        client.perform(request: request) { result in
            switch result {
            case .success:
                break
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

final class AddNewUserServiceTests: XCTestCase {

    func test_init_doesNotSendNewUserPayloadByURL() {
        // given
        // when
        let (_, client) = makeSUT(url: anyURL())
        
        // then
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_send_sendNewUserPayloadByURL() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.send(newUserPayload: anyNewUserPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_send_sendsNewUserPayloadByURLTwice() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.send(newUserPayload: anyNewUserPayload()) { _ in }
        sut.send(newUserPayload: anyNewUserPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_send_deliversConnectivityErrorOnClientError() {
        // given
        let (sut, client) = makeSUT()
        
        // when
        let exp = expectation(description: "Wait for completion")
        var receivedError: AddNewUserService.Error?
        sut.send(newUserPayload: anyNewUserPayload()) { result in
            switch result {
            case let .failure(error):
                receivedError = error
                
            default:
                XCTFail("Expected failure, got \(result) instead.")
            }
            
            exp.fulfill()
        }
        
        client.complete(with: NSError(domain: "any error", code: 0))
        
        wait(for: [exp], timeout: 1.0)
        
        // then
        XCTAssertEqual(receivedError, .connectivity)
    }
    
    // 5. send() delivers server error on 500 HTTP response
    // 6. send() delivers unknown error on non 200 HTTP response
    // 7. send() delivers invalid data error on 200 HTTP response with invalid body
    // 8. send() does not deliver result on client error after instance has been deallocated
    // 9. send() does not deliver result on 500 HTTP response after instance has been deallocated
    // 10. send() does not deliver result on non 200 HTTP response after instance has been deallocated
    // 11. send() does not deliver result on 200 HTTP response after instance has been deallocated
    // 12. send() delivers new user info on 200HTTP response with valid body
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (AddNewUserService, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = AddNewUserService(url: url, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private func anyNewUserPayload() -> NewUserPayload {
        NewUserPayload(
            name: "user name",
            email: "user@example.com",
            avatarName: "avatar name",
            avatarColor: "avatar color")
    }
    
    private class HTTPClientSpy: HTTPClientProtocol {
        private var messages = [Message]()
        
        var requestedURLs: [URL] {
            messages.compactMap { $0.request.url }
        }
        
        private struct Message {
            let request:  URLRequest
            let completion: (HTTPClientResult) -> Void
            
            init(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
                self.request = request
                self.completion = completion
            }
        }
        
        func perform(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append(Message(request: request, completion: completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[0].completion(.failure(error))
        }
    }
}
