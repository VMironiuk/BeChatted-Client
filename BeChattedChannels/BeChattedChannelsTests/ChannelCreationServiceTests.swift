//
//  ChannelCreationServiceTests.swift
//  BeChattedChannelsTests
//
//  Created by Volodymyr Myroniuk on 22.05.2024.
//

import XCTest
import BeChattedChannels

final class ChannelCreationServiceTests: XCTestCase {
    
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

    func test_createChannel_sendsCreateChannelRequestByURL() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.createChannel(payload: anyCreateChannelPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_createChannel_sendsCreateChannelRequestByURLTwice() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
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
    
    func test_createChannel_deliversSuccessfulResultOn200HTTPResponse() {
        // given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for create channel request completion")
        
        // when
        sut.createChannel(payload: anyCreateChannelPayload()) { result in
            // then
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail("Expected success, got \(error) instead")
            }
            exp.fulfill()
        }
        client.complete(with: httpResponse(with: 200))
        wait(for: [exp], timeout: 1)
    }
    
    func test_createChannel_deliversServerErrorOn500HTTPResponse() {
        // given
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for create channel request completion")
        
        // when
        sut.createChannel(payload: anyCreateChannelPayload()) { result in
            // then
            switch result {
            case .success:
                XCTFail("Expected failure, got \(result) instead")
            case .failure(let error) where error == .server:
                break
            default:
                XCTFail("Expected server error, got \(result) instead")
            }
            exp.fulfill()
        }
        client.complete(with: httpResponse(with: 500))
        wait(for: [exp], timeout: 1)
    }
    
    func test_createChannel_doesNotDeliverResultAfterSUTInstanceDeallocated() {
        // given
        let client = HTTPClientSpy()
        var sut: ChannelCreationService? = ChannelCreationService(url: anyURL(), authToken: anyAuthToken(), client: client)

        var expectedResult: Result<Void, ChannelCreatingError>?
        sut?.createChannel(payload: anyCreateChannelPayload()) { expectedResult = $0 }
        
        // when
        sut = nil
        client.complete(with: httpResponse(with: 200))
        
        // then
        XCTAssertNil(expectedResult)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        authToken: String = "any token",
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (ChannelCreationService, HTTPClientSpy) {
        let client  = HTTPClientSpy()
        let sut = ChannelCreationService(url: url, authToken: authToken, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func anyCreateChannelPayload() -> CreateChanelPayload {
        CreateChanelPayload(name: "any name", description: "any description")
    }
}
