//
//  UserLogoutServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 07.04.2023.
//

import XCTest
import BeChatted

final class UserLogoutService {
    private let url: URL
    private let client: HTTPClientProtocol
    
    enum Error: Swift.Error {
        case connectivity
    }
    
    init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success:
                break
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

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
        
        var receivedError: UserLogoutService.Error?
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
    
    func test_logout_doesNotDeliverErrorAfterInstanceHasBeenDeallocated() {
        // given
        let url = anyURL()
        let client = HTTPClientSpy()
        var sut: UserLogoutService? = UserLogoutService(url: url, client: client)
        
        var receivedError: UserLogoutService.Error?
        sut?.logout() { result in
            switch result {
            case let .failure(error):
                receivedError = error
                
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
        }
        
        // when
        sut = nil
        
        client.complete(withError: NSError(domain: "any error", code: 0))
        
        // then
        XCTAssertNil(receivedError)
    }
    
    func test_logout_doesNotDeliverResultAfterInstanceHasBeenDeallocated() {
        // given
        let url = anyURL()
        let client = HTTPClientSpy()
        var sut: UserLogoutService? = UserLogoutService(url: url, client: client)
        
        var receivedResult: Result<Void, UserLogoutService.Error>?
        sut?.logout() { result in
            receivedResult = result
        }
        
        // when
        sut = nil
        
        client.complete()
        
        // then
        XCTAssertNil(receivedResult)
    }

    // 6. logout() delivers successful result on any HTTP response
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (UserLogoutService, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = UserLogoutService(url: url, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private class HTTPClientSpy: HTTPClientProtocol {
        private var messages = [Message]()
        
        var requestedURLs: [URL] {
            messages.compactMap { $0.request.url }
        }
        
        private struct Message {
            let request: URLRequest
            let completion: (HTTPClientResult) -> Void
        }
        
        func perform(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append(Message(request: request, completion: completion))
        }
        
        func complete(withError error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(at index: Int = 0) {
            messages[index].completion(.success(nil, nil))
        }
    }
}
