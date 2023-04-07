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
    
    init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    func send() {
        let request = URLRequest(url: url)
        
        client.perform(request: request, completion: { _ in })
    }
}

final class UserLogoutServiceTests: XCTestCase {
    
    func test_init_doesNotSendRequestByURL() {
        // given
        let client = HTTPClientSpy()
        let url = URL(string: "http://any-url.com")!
        
        // when
        _ = UserLogoutService(url: url, client: client)
        
        // then
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_send_sendsLogoutRequestByURL() {
        // given
        let client = HTTPClientSpy()
        let url = URL(string: "http://any-url.com")!
        let sut = UserLogoutService(url: url, client: client)
        
        // when
        sut.send()
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_send_sendsLogoutRequestByURLTwice() {
        // given
        let client = HTTPClientSpy()
        let url = URL(string: "http://any-url.com")!
        let sut = UserLogoutService(url: url, client: client)
        
        // when
        sut.send()
        sut.send()
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    // 4. send() delivers connectivity error on client error
    // 5. send() does not deliver result after the instance has been deallocated
    // 6. send() delivers successful result on any HTTP response
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClientProtocol {
        private(set) var requestedURLs = [URL]()
        
        func perform(request: URLRequest, completion: @escaping (BeChatted.HTTPClientResult) -> Void) {
            if let url = request.url {
                requestedURLs.append(url)
            }
        }
    }
}
