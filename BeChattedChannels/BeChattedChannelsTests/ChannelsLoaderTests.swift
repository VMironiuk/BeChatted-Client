//
//  ChannelsLoaderTests.swift
//  BeChattedChannelsTests
//
//  Created by Volodymyr Myroniuk on 04.04.2024.
//

import XCTest

public protocol HTTPClientProtocol {
    func perform(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void)
}

final class ChannelsLoader {
    private let url: URL
    private let authToken: String
    private let client: HTTPClientProtocol
    
    init(url: URL, authToken: String, client: HTTPClientProtocol) {
        self.url = url
        self.authToken = authToken
        self.client = client
    }
    
    func load() {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        client.perform(request: request) { _ in }
    }
}

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
        sut.load()
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_sendsRequestByURLTwice() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.load()
        sut.load()
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_sendsRequestAsGETMethod() {
        // given
        let (sut, client) = makeSUT()
        
        // when
        sut.load()
        
        // then
        XCTAssertEqual(client.httpMethods, ["GET"])
    }
    
    func test_load_sendsRequestAsApplicationJSONContentType() {
        // given
        let (sut, client) = makeSUT()
        
        // when
        sut.load()
        
        // then
        XCTAssertEqual(client.contentTypes, ["application/json"])
    }
    
    func test_load_sendsRequestWithAuthToken() {
        // given
        let anyAuthToken = anyAuthToken()
        let (sut, client) = makeSUT(authToken: anyAuthToken)
        
        // when
        sut.load()
        
        // then
        XCTAssertEqual(client.authTokens, ["Bearer \(anyAuthToken)"])
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
    }
}
