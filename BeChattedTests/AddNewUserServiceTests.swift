//
//  AddNewUserServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 28.03.2023.
//

import XCTest
import BeChatted

struct NewUserPayload {}

class AddNewUserService {
    private let url: URL
    private let client: HTTPClientProtocol
    
    init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    func send(newUserPayload: NewUserPayload) {
        let request = URLRequest(url: url)
        
        client.perform(request: request) { _ in }
    }
}

final class AddNewUserServiceTests: XCTestCase {

    func test_init_doesNotSendNewUserPayloadByURL() {
        // given
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        
        // when
        _ = AddNewUserService(url: url, client: client)
        
        // then
        XCTAssertNil(client.requestedURL)
    }
    
    func test_send_sendNewUserPayloadByURL() {
        // given
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        let sut = AddNewUserService(url: url, client: client)
        let newUserPayload = NewUserPayload()
        
        // when
        sut.send(newUserPayload: newUserPayload)
        
        // then
        XCTAssertNotNil(client.requestedURL)
    }
    
    // 3. send() sends new user payload by URL twice
    // 4. send() delivers connectivity error on client error
    // 5. send() delivers server error on 500 HTTP response
    // 6. send() delivers unknown error on non 200 HTTP response
    // 7. send() delivers invalid data error on 200 HTTP response with invalid body
    // 8. send() does not deliver result on client error after instance has been deallocated
    // 9. send() does not deliver result on 500 HTTP response after instance has been deallocated
    // 10. send() does not deliver result on non 200 HTTP response after instance has been deallocated
    // 11. send() does not deliver result on 200 HTTP response after instance has been deallocated
    // 12. send() delivers new user info on 200HTTP response with valid body
    
    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClientProtocol {
        private(set) var requestedURL: URL?
        
        func perform(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            requestedURL = request.url
        }
    }
}
