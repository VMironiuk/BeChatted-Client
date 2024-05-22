//
//  ChannelsViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 23.04.2024.
//

import XCTest
import BeChatted

final class ChannelsViewModelTests: XCTestCase {
    
    func test_init_doesNotSendLoadRequest() {
        // given
        
        // when
        let service = ChannelsLoadingServiceStub()
        _ = ChannelsViewModel(channelsLoadingService: service)
        
        // then
        XCTAssertEqual(service.loadChannelsCallCount, 0)
    }
    
    func test_loadChanels_returnsEmptyIfThereAreNoChannels() {
        // given
        let (sut, service) = makeSUT()
        
        // when
        sut.loadChannels()
        service.completeChannelsLoading(with: .success([]))
        
        // then
        switch sut.loadChannelsResult {
        case .success(let channels):
            XCTAssertTrue(channels.isEmpty, "Expected empty channels, got \(channels) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_loadChanels_returnsChannelsIfThereAreChannels() {
        // given
        let loadedChannels = [makeChannel(with: "A", description: "AAA"), makeChannel(with: "B", description: "BBB")]
        let expectedChannelItems = [.title, makeChannelItem(with: "A"), makeChannelItem(with: "B")]
        let (sut, service) = makeSUT()
        
        // when
        sut.loadChannels()
        service.completeChannelsLoading(with: .success(loadedChannels))
        
        // then
        switch sut.loadChannelsResult {
        case .success(let gotChannels):
            XCTAssertEqual(gotChannels, expectedChannelItems)
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_loadChanels_returnsUnknownErrorOnUnknownError() {
        // given
        let (sut, service) = makeSUT()
        
        // when
        sut.loadChannels()
        service.completeChannelsLoading(with: .failure(.unknown))
        
        // then
        switch sut.loadChannelsResult {
        case .failure(let receivedError):
            XCTAssertEqual(receivedError, .unknown, "Expected unknown error, got \(receivedError) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_loadChanels_returnsConnectivityErrorOnConnectivityError() {
        // given
        let (sut, service) = makeSUT()
        
        // when
        sut.loadChannels()
        service.completeChannelsLoading(with: .failure(.connectivity))
        
        // then
        switch sut.loadChannelsResult {
        case .failure(let receivedError):
            XCTAssertEqual(receivedError, .connectivity, "Expected connectivity error, got \(receivedError) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_loadChanels_returnsInvalidDataErrorOnInvalidDataError() {
        // given
        let (sut, service) = makeSUT()
        
        // when
        sut.loadChannels()
        service.completeChannelsLoading(with: .failure(.invalidData))
        
        // then
        switch sut.loadChannelsResult {
        case .failure(let receivedError):
            XCTAssertEqual(receivedError, .invalidData, "Expected connectivity error, got \(receivedError) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (ChannelsViewModel, ChannelsLoadingServiceStub) {
        let service = ChannelsLoadingServiceStub()
        let sut = ChannelsViewModel(channelsLoadingService: service)
        
        trackForMemoryLeaks(service, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, service)
    }
    
    private func makeChannel(with name: String, description: String) -> Channel {
        .init(id: UUID().uuidString, name: name, description: description)
    }
    
    private func makeChannelItem(with name: String) -> ChannelItem {
        .channel(name: name, isUnread: false)
    }
    
    private final class ChannelsLoadingServiceStub: ChannelsLoadingServiceProtocol {
        private var loadChannelsCompletions = [(Result<[Channel], ChannelsLoadingServiceError>) -> Void]()
        
        var loadChannelsCallCount: Int {
            loadChannelsCompletions.count
        }
        
        func loadChannels(completion: @escaping (Result<[Channel], ChannelsLoadingServiceError>) -> Void) {
            loadChannelsCompletions.append(completion)
        }
        
        func completeChannelsLoading(with result: Result<[Channel], ChannelsLoadingServiceError>, at index: Int = 0) {
            loadChannelsCompletions[index](result)
        }
    }
}
