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
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.loadChannels { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadChannels_sendsLoadChannelsRequestByURLTwice() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
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
        var sut: ChannelsService? = ChannelsService(url: anyURL(), authToken: anyAuthToken(), client: client)
        
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
        var sut: ChannelsService? = ChannelsService(url: anyURL(), authToken: anyAuthToken(), client: client)

        var expectedResult: Result<[ChannelInfo], ChannelsLoadingError>?
        sut?.loadChannels { expectedResult = $0 }
        
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
    ) -> (ChannelsService, HTTPClientSpy) {
        let client  = HTTPClientSpy()
        let sut = ChannelsService(url: url, authToken: authToken, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func anyNSError() -> Error {
        NSError(domain: "any domain", code: 1)
    }    
}
