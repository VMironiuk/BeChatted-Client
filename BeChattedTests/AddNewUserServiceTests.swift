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
        case server
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
            case let .success(_, response):
                if response?.statusCode == 500 {
                    completion(.failure(.server))
                }
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
        let (sut, client) = makeSUT()
        
        expect(sut: sut, toCompleteWithError: .connectivity, when: {
            client.complete(withError: NSError(domain: "any error", code: 0))
        })
    }
    
    func test_send_deliversServerErrorOn500HTTPResponse() {
        let (sut, client) = makeSUT()
        
        expect(sut: sut, toCompleteWithError: .server, when: {
            client.complete(withHTTPResponse: httpResponse(withStatusCode: 500))
        })
    }
    
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
    
    private func expect(
        sut: AddNewUserService,
        toCompleteWithError expectedError: AddNewUserService.Error,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        let exp = expectation(description: "Wait for completion")
        var receivedError: AddNewUserService.Error?
        
        sut.send(newUserPayload: anyNewUserPayload()) { result in
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
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private func httpResponse(withStatusCode code: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: code, httpVersion: nil, headerFields: nil)!
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
        
        func complete(withError error: Error, at index: Int = 0) {
            messages[0].completion(.failure(error))
        }
        
        func complete(withHTTPResponse response: HTTPURLResponse, at index: Int = 0) {
            messages[index].completion(.success(nil, response))
        }
    }
}
