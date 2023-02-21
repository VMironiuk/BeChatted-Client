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
        
        XCTAssertEqual(client.requestedURLs, [])
        XCTAssertEqual(client.newAccountInfos, [])
        XCTAssertEqual(client.httpMethods, [])
    }
    
    func test_send_sendsNewAccountInfoByURL() {
        let url = URL(string: "http://some-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        sut.send(newAccountInfo: newAccountInfo)
        
        XCTAssertEqual(client.requestedURLs, [url])
        XCTAssertEqual(client.newAccountInfos, [newAccountInfo])
        XCTAssertEqual(client.httpMethods, ["POST"])
    }
    
    func test_send_sendsNewAccountInfoByURLTwice() {
        let url = URL(string: "http://some-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        let newAccountInfo1 = NewAccountInfo(email: "my@example.com", password: "123456")
        let newAccountInfo2 = NewAccountInfo(email: "my.other@example.com", password: "31415")
        sut.send(newAccountInfo: newAccountInfo1)
        sut.send(newAccountInfo: newAccountInfo2)
        
        XCTAssertEqual(client.requestedURLs, [url, url])
        XCTAssertEqual(client.newAccountInfos, [newAccountInfo1, newAccountInfo2])
        XCTAssertEqual(client.httpMethods, ["POST", "POST"])
    }
    
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
        private var requests = [URLRequest]()
        
        var requestedURLs: [URL] {
            requests.compactMap {
                $0.url
            }
        }
        
        var httpMethods: [String] {
            requests.compactMap {
                $0.httpMethod
            }
        }

        var newAccountInfos: [NewAccountInfo] {
            requests.compactMap {
                guard let data = $0.httpBody else {
                    return nil
                }
                
                return try? JSONDecoder().decode(NewAccountInfo.self, from: data)
            }
        }
            
        func perform(request: URLRequest) {
            requests.append(request)
        }
    }
}
