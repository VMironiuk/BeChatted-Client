//
//  NewAccountServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 18.02.2023.
//

import XCTest
@testable import BeChattedAuth

final class NewAccountServiceTests: XCTestCase {

    func test_init_doesNotSendNewAccountRequestByURL() {
        // given
        
        // when
        let (_, client) = makeSUT()
        
        // then
        XCTAssertEqual(client.requestedURLs, [])
        XCTAssertEqual(client.newAccountPayloads, [])
        XCTAssertEqual(client.httpMethods, [])
    }
    
    func test_send_sendsNewAccountRequestByURL() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        let newAccountPayload = anyNewAccountPayload()
        
        // when
        sut.send(newAccountPayload: newAccountPayload) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_send_sendsNewAccountRequestByURLTwice() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        let newAccountPayload = anyNewAccountPayload()
        
        // when
        sut.send(newAccountPayload: newAccountPayload) { _ in }
        sut.send(newAccountPayload: newAccountPayload) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_send_sendsNewAccountPayload() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        let newAccountPayload = anyNewAccountPayload()
        
        // when
        sut.send(newAccountPayload: newAccountPayload) { _ in }
        
        // then
        XCTAssertEqual(client.newAccountPayloads, [newAccountPayload])
    }
    
    func test_send_sendsNewAccountRequestAsPOSTMethod() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        let newAccountPayload = anyNewAccountPayload()
        
        // when
        sut.send(newAccountPayload: newAccountPayload) { _ in }
        
        // then
        XCTAssertEqual(client.httpMethods, ["POST"])
    }
    
    func test_send_sendsNewAccountRequestAsApplicationJSONContentType() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        let newAccountPayload = anyNewAccountPayload()
        
        // when
        sut.send(newAccountPayload: newAccountPayload) { _ in }
        
        // then
        XCTAssertEqual(client.contentTypes, ["application/json"])
    }

    func test_send_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .connectivity, when: {
            client.complete(with: anyNSError())
        })
    }
    
    func test_send_deliversUnknownErrorOnNon200OrNon300OrNon500To599HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [100, 199, 201, 299, 301, 399]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithError: .unknown, when: {
                client.complete(with: httpResponse(withStatusCode: code), at: index)
            })
        }
    }
    
    func test_send_deliversServerErrorOn500To599HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [500, 511, 599]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithError: .server, when: {
                client.complete(with: httpResponse(withStatusCode: code), at: index)
            })
        }
    }
    
    func test_send_deliversEmailExistsErrorOn300HTTPResponse() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .email, when: {
            client.complete(with: httpResponse(withStatusCode: 300))
        })
    }
    
    func test_send_deliversSuccessfulResultOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithSuccessWhen: {
            client.complete(with: httpResponse(withStatusCode: 200))
        })
    }
    
    func test_send_doesNotDeliverErrorAfterSUTInstanceDeallocated() {
        let client = HTTPClientSpy()
        var sut: NewAccountServiceProtocol? = NewAccountService(url: anyURL(), client: client)
        
        expect(&sut, deliversNoResultWhen: {
            client.complete(with: anyNSError())
        })
    }
    
    func test_send_doesNotDeliverErrorOnNon200HTTPResponseAfterSUTInstanceDeallocated() {
        let client = HTTPClientSpy()
        var sut: NewAccountServiceProtocol? = NewAccountService(url: anyURL(), client: client)
        
        expect(&sut, deliversNoResultWhen: {
            client.complete(with: httpResponse(withStatusCode: 300))
        })
    }
    
    func test_send_doesNotDeliverSuccessAfterSUTInstanceDeallocated() {
        let client = HTTPClientSpy()
        var sut: NewAccountServiceProtocol? = NewAccountService(url: anyURL(), client: client)
        
        expect(&sut, deliversNoResultWhen: {
            client.complete(with: httpResponse(withStatusCode: 200))
        })
    }

    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: NewAccountServiceProtocol, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = NewAccountService(url: url, client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)

        return (sut, client)
    }
        
    private func expect(
        _ sut: NewAccountServiceProtocol,
        toCompleteWithError expectedError: NewAccountServiceError,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        let exp = expectation(description: "Wait for completion")
        var receivedError: NewAccountServiceError?
        sut.send(newAccountPayload: anyNewAccountPayload()) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        // when
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        // then
        XCTAssertEqual(receivedError, expectedError, file: file, line: line)
    }
    
    private func expect(
        _ sut: NewAccountServiceProtocol,
        toCompleteWithSuccessWhen action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        let exp = expectation(description: "Wait for completion")
        var receivedResult: Result<Void, NewAccountServiceError>?
        sut.send(newAccountPayload: anyNewAccountPayload()) { result in
            switch result {
            case .success:
                receivedResult = result
            default:
                XCTFail("Expected successful result, got \(result) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        // when
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        // then
        XCTAssertNotNil(receivedResult, file: file, line: line)
    }
    
    private func expect(
        _ sut: inout NewAccountServiceProtocol?,
        deliversNoResultWhen action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        var receivedResult: Result<Void, NewAccountServiceError>?
        sut?.send(newAccountPayload: anyNewAccountPayload()) { result in
            receivedResult = result
        }
        
        // when
        sut = nil
        
        action()
        
        // then
        XCTAssertNil(receivedResult, file: file, line: line)
    }

    private class HTTPClientSpy: HTTPClientProtocol {
        private var messages = [(request: URLRequest, completion: (Result<(Data?, HTTPURLResponse?), Error>) -> Void)]()
                
        var requestedURLs: [URL] {
            messages.compactMap { $0.request.url }
        }
        
        var httpMethods: [String] {
            messages.compactMap { $0.request.httpMethod }
        }
        
        var contentTypes: [String] {
            messages.compactMap { $0.request.value(forHTTPHeaderField: "Content-Type") }
        }

        var newAccountPayloads: [NewAccountPayload] {
            messages.compactMap {
                guard let data = $0.request.httpBody else { return nil }
                return try? JSONDecoder().decode(NewAccountPayload.self, from: data)
            }
        }
            
        func perform(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void) {
            messages.append((request, completion))
        }
                
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(with response: HTTPURLResponse, at index: Int = 0) {
            messages[index].completion(.success((nil, response)))
        }
    }
    
    private func anyNewAccountPayload() -> NewAccountPayload {
        NewAccountPayload(email: "my@example.com", password: "123456")
    }
}
