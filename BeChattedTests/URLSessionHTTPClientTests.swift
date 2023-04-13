//
//  URLSessionHTTPClientTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 13.04.2023.
//

import XCTest
import BeChatted

final class URLSessionHTTPClient: HTTPClientProtocol {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func perform(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: request) { _, _, _ in }
    }
}

final class URLSessionHTTPClientTests: XCTestCase {

    func test_performRequest_createsDataTaskWithURLRequest() {
        let request = URLRequest(url: URL(string: "http://any-url.com")!)
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        sut.perform(request: request) { _ in }
        
        XCTAssertEqual(session.receivedRequests, [request])
    }
    
    // MARK: - Helpers
    
    private class URLSessionSpy: URLSession {
        private(set) var receivedRequests = [URLRequest]()
        
        override func dataTask(
            with request: URLRequest,
            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) -> URLSessionDataTask {
            receivedRequests.append(request)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {}
}
