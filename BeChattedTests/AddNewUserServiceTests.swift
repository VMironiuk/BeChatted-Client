//
//  AddNewUserServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 28.03.2023.
//

import XCTest

class HTTPClientSpy {
    private(set) var requestedURL: URL?
}

class AddNewUserService {
    private let url: URL
    private let client: HTTPClientSpy
    
    init(url: URL, client: HTTPClientSpy) {
        self.url = url
        self.client = client
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
    
    // 2. send() sends new user payload by URL
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
}
