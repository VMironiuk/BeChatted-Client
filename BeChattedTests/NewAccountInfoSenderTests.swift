//
//  NewAccountInfoSenderTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 18.02.2023.
//

import XCTest
import BeChatted

protocol HTTPClientProtocol {
    func perform(request: URLRequest)
}

class NewAccountInfoSender {
    private let url: URL
    private let client: HTTPClientProtocol
    
    init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    func send(newAccountInfo: NewAccountInfo) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(newAccountInfo)
        
        client.perform(request: request)
    }
}

final class NewAccountInfoSenderTests: XCTestCase {

    func test_init_doesNotSendNewAccountInfoByURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
        XCTAssertNil(client.newAccountInfo)
    }
    
    func test_send_sendsNewAccountInfoByURL() {
        let url = URL(string: "http://some-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        sut.send(newAccountInfo: newAccountInfo)
        
        XCTAssertEqual(client.requestedURL, url)
        XCTAssertEqual(client.newAccountInfo, newAccountInfo)
        XCTAssertEqual(client.httpMethod, "POST")
    }
    
    // 3. call send() twice sends a new account info by url twice
    
    // 4. send() delivers error on client error (no connectivity error)
    
    // 5. send() delivers error on non 200 HTTP response
    
    // 6. send() delivers successful result on 200 HTTP response
    
    // 7. send() does not delivers result after SUT instance has been deallocated
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: NewAccountInfoSender, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = NewAccountInfoSender(url: url, client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)

        return (sut, client)
    }
    
    private func trackForMemoryLeaks(
        _ object: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(
                object,
                "Expected object to be nil. Potential memory leak",
                file: file,
                line: line
            )
        }
    }
    
    private class HTTPClientSpy: HTTPClientProtocol {
        private var request: URLRequest?
        
        var requestedURL: URL? {
            request?.url
        }
        
        var httpMethod: String? {
            request?.httpMethod
        }

        var newAccountInfo: NewAccountInfo? {
            guard let data = request?.httpBody else {
                return nil
            }
            
            return try? JSONDecoder().decode(NewAccountInfo.self, from: data)
        }
            
        func perform(request: URLRequest) {
            self.request = request
        }
    }
}
