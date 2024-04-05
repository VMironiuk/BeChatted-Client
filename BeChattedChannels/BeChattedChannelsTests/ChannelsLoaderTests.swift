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
        let request = URLRequest(url: url)
        client.perform(request: request) { _ in }
    }
}

final class ChannelsLoaderTests: XCTestCase {
    
    func test_init_doesNotSendRequest() {
        let client  = HTTPClientSpy()
        _ = ChannelsLoader(url: anyURL(), authToken: "any token", client: client)
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_load_sendsRequest() {
        let client  = HTTPClientSpy()
        let url = anyURL()
        let sut = ChannelsLoader(url: url, authToken: "any token", client: client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    // MARK: - Helpers
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
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
