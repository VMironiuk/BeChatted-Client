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
        session.dataTask(with: request) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {

    func test_performRequest_resumesDataTaskWithURLRequest() {
        let request = URLRequest(url: URL(string: "http://any-url.com")!)
        let task = URLSessionDataTaskSpy()
        let session = URLSessionSpy()
        session.stub(request: request, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.perform(request: request) { _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_performRequest_failsOnRequestError() {
        let request = URLRequest(url: URL(string: "http://any-url.com")!)
        let task = URLSessionDataTaskSpy()
        let error = NSError(domain: "any error", code: 1)
        let session = URLSessionSpy()
        session.stub(request: request, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "Wait for completion")
        sut.perform(request: request) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private class URLSessionSpy: URLSession {
        private var stubs = [URLRequest: Stub]()
        
        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }
        
        func stub(request: URLRequest, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[request] = Stub(task: task, error: error)
        }
        
        override func dataTask(
            with request: URLRequest,
            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) -> URLSessionDataTask {
            guard let stub = stubs[request] else {
                fatalError("There is no data task for given \(request)")
            }
            
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        private(set) var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }
}
