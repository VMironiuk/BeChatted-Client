//
//  NewAccountInfoSenderTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 18.02.2023.
//

import XCTest
import BeChatted

final class NewAccountInfoSenderTests: XCTestCase {

    func test_init_doesNotSendNewAccountInfoByURL() {
        // given
        
        // when
        let (_, client) = makeSUT()
        
        // then
        XCTAssertEqual(client.requestedURLs, [])
        XCTAssertEqual(client.newAccountInfos, [])
        XCTAssertEqual(client.httpMethods, [])
    }
    
    func test_send_sendsNewAccountInfoByURL() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        
        // when
        sut.send(newAccountInfo: newAccountInfo) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
        XCTAssertEqual(client.newAccountInfos, [newAccountInfo])
        XCTAssertEqual(client.httpMethods, ["POST"])
    }
    
    func test_send_sendsNewAccountInfoByURLTwice() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        let newAccountInfo1 = NewAccountInfo(email: "my@example.com", password: "123456")
        let newAccountInfo2 = NewAccountInfo(email: "my.other@example.com", password: "31415")
        
        // when
        sut.send(newAccountInfo: newAccountInfo1) { _ in }
        sut.send(newAccountInfo: newAccountInfo2) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
        XCTAssertEqual(client.newAccountInfos, [newAccountInfo1, newAccountInfo2])
        XCTAssertEqual(client.httpMethods, ["POST", "POST"])
    }
    
    func test_send_deliversErrorOnClientError() {
        // given
        let clientError = anyNSError()
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        let (sut, client) = makeSUT()
        
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: NewAccountInfoSender.Error?
        
        // when
        sut.send(newAccountInfo: newAccountInfo) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        client.complete(with: clientError)
        
        wait(for: [exp], timeout: 1.0)
        
        // then
        XCTAssertEqual(receivedError, .connectivity)
    }
    
    func test_send_deliversErrorOnNon200HTTPResponse() {
        // given
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        let non200HTTPResponse = httpResponse(withStatusCode: 409)
        let (sut, client) = makeSUT()
        
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: NewAccountInfoSender.Error?
        
        // when
        sut.send(newAccountInfo: newAccountInfo) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        client.complete(withHTTPResponse: non200HTTPResponse)
        
        wait(for: [exp], timeout: 1.0)
        
        // then
        XCTAssertEqual(receivedError, .non200HTTPResponse)
    }
    
    func test_send_deliversSuccessfulResultOn200HTTPResponse() {
        // given
        let (sut, client) = makeSUT()
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        let httpResponseWith200StatusCode = httpResponse(withStatusCode: 200)
        
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: Result<Void, NewAccountInfoSender.Error>?
        
        // when
        sut.send(newAccountInfo: newAccountInfo) { result in
            switch result {
            case .success:
                receivedResult = result
            default:
                XCTFail("Expected successful result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        client.complete(withHTTPResponse: httpResponseWith200StatusCode)
        
        wait(for: [exp], timeout: 1.0)
        
        // then
        XCTAssertNotNil(receivedResult)
    }
    
    func test_send_doesNotDeliverErrorAfterSUTInstanceDeallocated() {
        // given
        let anyError = anyNSError()
        let anyURL = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: NewAccountInfoSender? = NewAccountInfoSender(url: anyURL, client: client)
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        
        var receivedResult: Result<Void, NewAccountInfoSender.Error>?
        sut?.send(newAccountInfo: newAccountInfo) { result in
            receivedResult = result
        }
        
        // when
        sut = nil
        
        client.complete(with: anyError)
        
        // then
        XCTAssertNil(receivedResult)
    }
    
    func test_send_doesNotDeliverErrorOnNon200HTTPResponseAfterSUTInstanceDeallocated() {
        // given
        let anyURL = anyURL()
        let non200HTTPResponse = httpResponse(withStatusCode: 300)
        let client = HTTPClientSpy()
        var sut: NewAccountInfoSender? = NewAccountInfoSender(url: anyURL, client: client)
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        
        var receivedResult: Result<Void, NewAccountInfoSender.Error>?
        sut?.send(newAccountInfo: newAccountInfo) { result in
            receivedResult = result
        }
        
        // when
        sut = nil
        
        client.complete(withHTTPResponse: non200HTTPResponse)
        
        // then
        XCTAssertNil(receivedResult)
    }
    
    func test_send_doesNotDeliverSuccessAfterSUTInstanceDeallocated() {
        // given
        let anyURL = anyURL()
        let httpResponseWith200StatusCode = httpResponse(withStatusCode: 200)
        let client = HTTPClientSpy()
        var sut: NewAccountInfoSender? = NewAccountInfoSender(url: anyURL, client: client)
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        
        var receivedResult: Result<Void, NewAccountInfoSender.Error>?
        sut?.send(newAccountInfo: newAccountInfo) { result in
            receivedResult = result
        }
        
        // when
        sut = nil
        
        client.complete(withHTTPResponse: httpResponseWith200StatusCode)
        
        // then
        XCTAssertNil(receivedResult)
    }

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
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private func anyNSError() -> Error {
        NSError(domain: "any error", code: 1)
    }
    
    private func httpResponse(withStatusCode statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    private class HTTPClientSpy: HTTPClientProtocol {
        private var requests = [URLRequest]()
        private var completion: ((HTTPClientResult) -> Void)?
                
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
            
        func perform(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            requests.append(request)
            self.completion = completion
        }
        
        func complete(with error: Error?) {
            completion?(.failure(error))
        }
        
        func complete(withHTTPResponse httpResponse: HTTPURLResponse?) {
            completion?(.success(nil, httpResponse))
        }
    }
}
