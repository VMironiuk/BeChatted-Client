//
//  ChannelsServiceTests.swift
//  BeChattedChannelsTests
//
//  Created by Volodymyr Myroniuk on 04.04.2024.
//

import XCTest
import BeChattedChannels

final class ChannelsServiceTests: XCTestCase {
    
    func test_init_doesNotSendRequests() {
        // given
        
        // when
        let (_, client) = makeSUT()
        
        // then
        XCTAssertEqual(client.requestedURLs, [])
        XCTAssertEqual(client.httpMethods, [])
        XCTAssertEqual(client.contentTypes, [])
        XCTAssertEqual(client.authTokens, [])
    }
    
    func test_loadChannels_sendsLoadChannelsRequestByURL() {
        // given
        let url = loadChannelsURL()
        let (sut, client) = makeSUT(loadChannelsURL: url)
        
        // when
        sut.loadChannels { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadChannels_sendsLoadChannelsRequestByURLTwice() {
        // given
        let url = loadChannelsURL()
        let (sut, client) = makeSUT(loadChannelsURL: url)
        
        // when
        sut.loadChannels { _ in }
        sut.loadChannels { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_loadChannels_sendsLoadChannelsRequestAsGETMethod() {
        // given
        let (sut, client) = makeSUT()
        
        // when
        sut.loadChannels { _ in }
        
        // then
        XCTAssertEqual(client.httpMethods, ["GET"])
    }
    
    func test_loadChannels_sendsLoadChannelsRequestAsApplicationJSONContentType() {
        // given
        let (sut, client) = makeSUT()
        
        // when
        sut.loadChannels { _ in }
        
        // then
        XCTAssertEqual(client.contentTypes, ["application/json"])
    }
    
    func test_loadChannels_sendsLoadChannelsRequestWithAuthToken() {
        // given
        let anyAuthToken = anyAuthToken()
        let (sut, client) = makeSUT(authToken: anyAuthToken)
        
        // when
        sut.loadChannels { _ in }
        
        // then
        XCTAssertEqual(client.authTokens, ["Bearer \(anyAuthToken)"])
    }
    
    func test_loadChannels_deliversChannelsOnValidAndNonEmptyChannelsData() {
        // given
        let (sut, client) = makeSUT()
        let expectedChannels = [ChannelInfo(id: "1", name: "a channel", description: "a description")]
        let channelsData = try! JSONEncoder().encode(expectedChannels)
        let exp = expectation(description: "Wait for channels loading completion")
        
        // when
        sut.loadChannels { result in
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
    
    func test_loadChannels_deliversNoChannelsOnValidButEmptyChannelsData() {
        // given
        let (sut, client) = makeSUT()
        let expectedChannels = [ChannelInfo]()
        let channelsData = try! JSONEncoder().encode(expectedChannels)
        let exp = expectation(description: "Wait for channels loading completion")
        
        // when
        sut.loadChannels { result in
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
    
    func test_loadChannels_deliversInvalidDataErrorOnInvalidChannelsData() {
        // given
        let (sut, client) = makeSUT()
        let channelsData = "{\"obj\": \"invalid\"}".data(using: .utf8)!
        let exp = expectation(description: "Wait for channels loading completion")
        
        // when
        sut.loadChannels { result in
            // then
            switch result {
            case let .success(receivedChannels):
                XCTFail("Expected invalid data error, got \(receivedChannels) instead")
            case let .failure(error):
                XCTAssertEqual(error, ChannelsLoadingError.invalidData)
            }
            exp.fulfill()
        }
        client.complete(with: channelsData)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_loadChannels_doesNotDeliverChannelsAfterSUTInstanceDeallocated() {
        // given
        let client = HTTPClientSpy()
        let configuration = ChannelsServiceConfiguration(
            loadChannelsURL: loadChannelsURL(),
            createChannelURL: createChannelURL(),
            authToken: anyAuthToken())
        var sut: ChannelsService? = ChannelsService(configuration: configuration, client: client)
        
        var expectedResult: Result<[ChannelInfo], ChannelsLoadingError>?
        sut?.loadChannels { expectedResult = $0 }
        
        // when
        sut = nil
        client.complete(with: try! JSONEncoder().encode([ChannelInfo]()))
        
        // then
        XCTAssertNil(expectedResult)
    }
    
    func test_loadChannels_deliversServerErrorOnNon200HTTPResponse() {
        // given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for channels loading completion")
        
        // when
        sut.loadChannels { result in
            // then
            switch result {
            case let .success(receivedChannels):
                XCTFail("Expected server error, got \(receivedChannels) instead")
            case let .failure(error):
                XCTAssertEqual(error, ChannelsLoadingError.server)
            }
            exp.fulfill()
        }
        client.complete(with: ChannelsLoadingError.server)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_loadChannels_doesNotDeliverErrorAfterSUTInstanceDeallocated() {
        // given
        let client = HTTPClientSpy()
        let configuration = ChannelsServiceConfiguration(
            loadChannelsURL: loadChannelsURL(),
            createChannelURL: createChannelURL(),
            authToken: anyAuthToken())
        var sut: ChannelsService? = ChannelsService(configuration: configuration, client: client)

        var expectedResult: Result<[ChannelInfo], ChannelsLoadingError>?
        sut?.loadChannels { expectedResult = $0 }
        
        // when
        sut = nil
        client.complete(with: anyNSError())
        
        // then
        XCTAssertNil(expectedResult)
    }
    
    func test_createChannel_sendsCreateChannelRequestByURL() {
        // given
        let url = createChannelURL()
        let (sut, client) = makeSUT(createChannelURL: url)
        
        // when
        sut.createChannel(payload: anyCreateChannelPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_createChannel_sendsCreateChannelRequestByURLTwice() {
        // given
        let url = createChannelURL()
        let (sut, client) = makeSUT(createChannelURL: url)
        
        // when
        sut.createChannel(payload: anyCreateChannelPayload()) { _ in }
        sut.createChannel(payload: anyCreateChannelPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_createChannel_sendsCreateChannelRequestAsPOSTMethod() {
        // given
        let (sut, client) = makeSUT()
        
        // when
        sut.createChannel(payload: anyCreateChannelPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.httpMethods, ["POST"])
    }
    
    func test_createChannel_sendsCreateChannelRequestAsApplicationJSONContentType() {
        // given
        let (sut, client) = makeSUT()
        
        // when
        sut.createChannel(payload: anyCreateChannelPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.contentTypes, ["application/json"])
    }
    
    func test_createChannel_sendsCreateChannelRequestWithAuthToken() {
        // given
        let anyAuthToken = anyAuthToken()
        let (sut, client) = makeSUT(authToken: anyAuthToken)
        
        // when
        sut.createChannel(payload: anyCreateChannelPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.authTokens, ["Bearer \(anyAuthToken)"])
    }
    
    func test_createChannel_sendsCreateChannelPayload() {
        // given
        let (sut, client) = makeSUT()
        let createChannelPayload = anyCreateChannelPayload()
        
        // when
        sut.createChannel(payload: createChannelPayload) { _ in }
        
        // then
        XCTAssertEqual(client.createChannelPayloads, [createChannelPayload])
    }

    // MARK: - Helpers
    
    private func makeSUT(
        loadChannelsURL: URL = URL(string: "http://load-channels-url.com")!,
        createChannelURL: URL = URL(string: "http://create-channel-url.com")!,
        authToken: String = "any token",
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (ChannelsService, HTTPClientSpy) {
        let client  = HTTPClientSpy()
        let configuration = ChannelsServiceConfiguration(
            loadChannelsURL: loadChannelsURL,
            createChannelURL: createChannelURL,
            authToken: authToken)
        let sut = ChannelsService(configuration: configuration, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func loadChannelsURL() -> URL {
        URL(string: "http://load-channels-url.com")!
    }
    
    private func createChannelURL() -> URL {
        URL(string: "http://create-channel-url.com")!
    }
    
    private func anyAuthToken() -> String {
        "any token"
    }
    
    private func anyNSError() -> Error {
        NSError(domain: "any domain", code: 1)
    }
    
    private func anyCreateChannelPayload() -> CreateChanelPayload {
        CreateChanelPayload(name: "any name", description: "any description")
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
        
        var createChannelPayloads: [CreateChanelPayload] {
            messages.compactMap {
                guard let data = $0.request.httpBody else { return nil }
                return try? JSONDecoder().decode(CreateChanelPayload.self, from: data)
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
        
        func complete(with data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: URL(string: "http://any-url.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
            messages[index].completion(.success((data, response)))
        }
    }
}
