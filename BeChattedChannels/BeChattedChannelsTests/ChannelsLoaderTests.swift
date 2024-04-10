//
//  ChannelsLoaderTests.swift
//  BeChattedChannelsTests
//
//  Created by Volodymyr Myroniuk on 04.04.2024.
//

import XCTest
import BeChattedChannels

final class ChannelsLoaderTests: XCTestCase {
    
    func test_init_doesNotSendRequest() {
        // given
        
        // when
        let (_, client) = makeSUT()
        
        // then
        XCTAssertEqual(client.requestedURLs, [])
        XCTAssertEqual(client.httpMethods, [])
        XCTAssertEqual(client.contentTypes, [])
        XCTAssertEqual(client.authTokens, [])
    }
    
    func test_load_sendsRequestByURL() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.load { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_sendsRequestByURLTwice() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.load { _ in }
        sut.load { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_sendsRequestAsGETMethod() {
        // given
        let (sut, client) = makeSUT()
        
        // when
        sut.load { _ in }
        
        // then
        XCTAssertEqual(client.httpMethods, ["GET"])
    }
    
    func test_load_sendsRequestAsApplicationJSONContentType() {
        // given
        let (sut, client) = makeSUT()
        
        // when
        sut.load { _ in }
        
        // then
        XCTAssertEqual(client.contentTypes, ["application/json"])
    }
    
    func test_load_sendsRequestWithAuthToken() {
        // given
        let anyAuthToken = anyAuthToken()
        let (sut, client) = makeSUT(authToken: anyAuthToken)
        
        // when
        sut.load { _ in }
        
        // then
        XCTAssertEqual(client.authTokens, ["Bearer \(anyAuthToken)"])
    }
    
    func test_load_deliversChannelsOnValidAndNonEmptyChannelsData() {
        // given
        let (sut, client) = makeSUT()
        let expectedChannels = [ChannelInfo(id: "1", name: "a channel", description: "a description")]
        let channelsData = try! JSONEncoder().encode(expectedChannels)
        let exp = expectation(description: "Wait for channels loading completion")
        
        // when
        sut.load { result in
            // then
            switch result {
            case let .success(receivedChannels):
                XCTAssertEqual(receivedChannels, expectedChannels)
            case let .failure(error):
                XCTFail("Expected channels, got \(error) instead")
            }
            exp.fulfill()
        }
        client.complete(with: channelsData)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_load_deliversNoChannelsOnValidButEmptyChannelsData() {
        // given
        let (sut, client) = makeSUT()
        let expectedChannels = [ChannelInfo]()
        let channelsData = try! JSONEncoder().encode(expectedChannels)
        let exp = expectation(description: "Wait for channels loading completion")
        
        // when
        sut.load { result in
            // then
            switch result {
            case let .success(receivedChannels):
                XCTAssertEqual(receivedChannels, expectedChannels)
            case let .failure(error):
                XCTFail("Expected channels, got \(error) instead")
            }
            exp.fulfill()
        }
        client.complete(with: channelsData)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_load_deliversInvalidDataErrorOnInvalidChannelsData() {
        // given
        let (sut, client) = makeSUT()
        let channelsData = "{\"obj\": \"invalid\"}".data(using: .utf8)!
        let exp = expectation(description: "Wait for channels loading completion")
        
        // when
        sut.load { result in
            // then
            switch result {
            case let .success(receivedChannels):
                XCTFail("Expected invalid data error, got \(receivedChannels) instead")
            case let .failure(error as ChannelsLoaderError):
                XCTAssertEqual(error, ChannelsLoaderError.invalidData)
            default:
                XCTFail("Expected invalid data error, got \(result) instead")
            }
            exp.fulfill()
        }
        client.complete(with: channelsData)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_load_doesNotDeliverChannelsAfterSUTInstanceDeallocated() {
        // given
        let client = HTTPClientSpy()
        var sut: ChannelsLoader? = ChannelsLoader(url: anyURL(), authToken: anyAuthToken(), client: client)
        
        var expectedResult: Result<[ChannelInfo], Error>?
        sut?.load { expectedResult = $0 }
        
        // when
        sut = nil
        client.complete(with: try! JSONEncoder().encode([ChannelInfo]()))
        
        // then
        XCTAssertNil(expectedResult)
    }
    
    func test_load_deliversServerErrorOnNon200HTTPResponse() {
        // given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for channels loading completion")
        
        // when
        sut.load { result in
            // then
            switch result {
            case let .success(receivedChannels):
                XCTFail("Expected server error, got \(receivedChannels) instead")
            case let .failure(error as ChannelsLoaderError):
                XCTAssertEqual(error, ChannelsLoaderError.server)
            default:
                XCTFail("Expected server error, got \(result) instead")
            }
            exp.fulfill()
        }
        client.complete(with: ChannelsLoaderError.server)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_load_doesNotDeliverErrorAfterSUTInstanceDeallocated() {
        // given
        let client = HTTPClientSpy()
        var sut: ChannelsLoader? = ChannelsLoader(url: anyURL(), authToken: anyAuthToken(), client: client)
        
        var expectedResult: Result<[ChannelInfo], Error>?
        sut?.load { expectedResult = $0 }
        
        // when
        sut = nil
        client.complete(with: anyNSError())
        
        // then
        XCTAssertNil(expectedResult)
    }

    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        authToken: String = "any token",
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (ChannelsLoader, HTTPClientSpy) {
        let client  = HTTPClientSpy()
        let url = anyURL()
        let sut = ChannelsLoader(url: url, authToken: anyAuthToken(), client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private func anyAuthToken() -> String {
        "any token"
    }
    
    private func anyNSError() -> Error {
        NSError(domain: "any domain", code: 1)
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
        
        var authTokens: [String] {
            messages.compactMap { $0.request.value(forHTTPHeaderField: "Authorization") }
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
        
        func complete(with data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: URL(string: "http://any-url.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            messages[index].completion(.success((data, response)))
        }
    }
}
