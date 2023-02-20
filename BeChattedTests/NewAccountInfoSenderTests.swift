//
//  NewAccountInfoSenderTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 18.02.2023.
//

import XCTest
import BeChatted

class HTTPClient {
    private(set) var requestedURL: URL?
    private(set) var newAccountInfo: NewAccountInfo?
}

class NewAccountInfoSender {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
}

final class NewAccountInfoSenderTests: XCTestCase {

    func test_init_doesNotSendNewAccountInfoByURL() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClient()
        
        _ = NewAccountInfoSender(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
        XCTAssertNil(client.newAccountInfo)
    }
    
    // 2. send() sends a new account info by url
    
    // 3. call send() twice sends a new account info by url twice
    
    // 4. send() delivers error on client error (no connectivity error)
    
    // 5. send() delivers error on non 200 HTTP response
    
    // 6. send() delivers successful result on 200 HTTP response
    
    // 7. send() does not delivers result after SUT instance has been deallocated
}
