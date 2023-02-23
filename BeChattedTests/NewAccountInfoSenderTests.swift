//
//  NewAccountInfoSenderTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 18.02.2023.
//

import XCTest
import BeChatted

protocol HTTPClientProtocol {
    func perform(request: URLRequest, completion: @escaping (HTTPURLResponse?, Error?) -> Void)
}

class NewAccountInfoSender {
    private let url: URL
    private let client: HTTPClientProtocol
    
    enum NewAccountInfoSenderError: Error {
        case connectivity
        case invalidResponse
    }
    
    init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    func send(newAccountInfo: NewAccountInfo, completion: @escaping (Result<Void, NewAccountInfoSenderError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(newAccountInfo)
        
        client.perform(request: request) { response, error in
            if error != nil {
                completion(.failure(.connectivity))
            } else if let response = response, response.statusCode != 200 {
                completion(.failure(.invalidResponse))
            } else if let response = response, response.statusCode == 200 {
                completion(.success(()))
            }
        }
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
        sut.send(newAccountInfo: newAccountInfo) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
        XCTAssertEqual(client.newAccountInfos, [newAccountInfo])
        XCTAssertEqual(client.httpMethods, ["POST"])
    }
    
    func test_send_sendsNewAccountInfoByURLTwice() {
        let url = URL(string: "http://some-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        let newAccountInfo1 = NewAccountInfo(email: "my@example.com", password: "123456")
        let newAccountInfo2 = NewAccountInfo(email: "my.other@example.com", password: "31415")
        sut.send(newAccountInfo: newAccountInfo1) { _ in }
        sut.send(newAccountInfo: newAccountInfo2) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
        XCTAssertEqual(client.newAccountInfos, [newAccountInfo1, newAccountInfo2])
        XCTAssertEqual(client.httpMethods, ["POST", "POST"])
    }
    
    func test_send_deliversErrorOnClientError() {
        let clientError = NSError(domain: "any error", code: 1)
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        let (sut, client) = makeSUT()
        
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: NewAccountInfoSender.NewAccountInfoSenderError?
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
        
        XCTAssertEqual(receivedError, .connectivity)
    }
    
    func test_send_deliversErrorOnNon200HTTPResponse() {
        let clientError = NSError(domain: "any error", code: 1)
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        let non200HTTPResponse = HTTPURLResponse(
            url: URL(string: "any-url.com")!,
            statusCode: 409,
            httpVersion: nil,
            headerFields: nil
        )
        let (sut, client) = makeSUT()
        
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: NewAccountInfoSender.NewAccountInfoSenderError?
        sut.send(newAccountInfo: newAccountInfo) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        client.complete(withHTTPResponse: non200HTTPResponse, error: clientError )
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError, .invalidResponse)
    }
    
    func test_send_deliversSuccessfulResultOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        let newAccountInfo = NewAccountInfo(email: "my@example.com", password: "123456")
        let httpResponse = HTTPURLResponse(
            url: URL(string: "http://any-url.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: Result<Void, NewAccountInfoSender.NewAccountInfoSenderError>?
        sut.send(newAccountInfo: newAccountInfo) { result in
            switch result {
            case .success:
                receivedResult = result
            default:
                XCTFail("Expected successful result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        client.complete(withHTTPResponse: httpResponse, error: nil)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNotNil(receivedResult)
    }
    
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
        private var completion: ((HTTPURLResponse?, Error?) -> Void)?
        
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
            
        func perform(request: URLRequest, completion: @escaping (HTTPURLResponse?, Error?) -> Void) {
            requests.append(request)
            self.completion = completion
        }
        
        func complete(with error: Error?) {
            completion?(nil, error)
        }
        
        func complete(withHTTPResponse httpResponse: HTTPURLResponse?, error: Error?) {
            completion?(httpResponse, nil)
        }
    }
}
