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
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func send(userLoginPayload: UserLoginPayload) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(userLoginPayload)
        
        client.perform(request: request) { _, _, _ in }
    }
}

final class UserLoginServiceTests: XCTestCase {
    
    func test_init_doesNotSendUserLoginPayloadByURL() {
        // given
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        
        // when
        _ = UserLoginService(url: url, client: client)
        
        // then
        XCTAssertNil(client.requestedURL)
    }
    
    // 2. send() sends user login payload by URL
    func test_send_sendsUserLoginPayloadByURL() {
        // given
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        let sut = UserLoginService(url: url, client: client)
        
        let userLoginPayload = UserLoginPayload(email: "my@example.com", password: "123456")
        
        // when
        sut.send(userLoginPayload: userLoginPayload)
        
        // then
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // 3. call send() twice sends user login payload by URL twice
    // 4. send() delivers connectivity error if there is no connectivity
    // 5. send() delivers invalid credentials error on 401 HTTP response
    // 6. send() delivers server error on 500...599 HTTP response
    // 7. send() delivers unknown error on non 200, 401 and 500...599 HTTP responses
    // 8. send() delivers invalid data error on 200 HTTP response with invalid responses body
    // 9. send() does not deliver error after instance has been deallocated
    // 10. send() does not deliver error on non 200 HTTP response after instance has been deallocated
    // 11. send() does not deliver user(name) and token on 200 HTTP response after instance has been deallocated
    // 10. send() delivers user(name) and token on 200 HTTP response
    
    // MARK: - Helpers
    
    private final class HTTPClientSpy: HTTPClient {
        private(set) var requestedURL: URL?
        
        func perform(request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
            requestedURL = request.url
        }
    }
}
