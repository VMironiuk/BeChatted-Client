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
        let client = HTTPClientSpy()
        let url = URL(string: "http://any-url.com")!
        _ = UserLogoutService(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_send_sendsLogoutRequestByURL() {
        // given
        let client = HTTPClientSpy()
        let url = URL(string: "http://any-url.com")!
        let sut = UserLogoutService(url: url, client: client)
        
        // when
        sut.send()
        
        // then
        XCTAssertNotNil(client.requestedURL)
    }

    // 3. send() sends logout request by URL twice
    // 4. send() delivers connectivity error on client error
    // 5. send() does not deliver result after the instance has been deallocated
    // 6. send() delivers successful result on any HTTP response
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClientProtocol {
        private(set) var requestedURL: URL?
        
        func perform(request: URLRequest, completion: @escaping (BeChatted.HTTPClientResult) -> Void) {
            requestedURL = request.url
        }
    }
}
