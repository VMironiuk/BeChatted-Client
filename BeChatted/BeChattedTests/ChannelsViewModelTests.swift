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
        let service = ChannelsServiceStub()
        _ = ChannelsViewModel(channelsService: service)
        
        // then
        XCTAssertEqual(service.loadCallCount, 0)
    }
    
    func test_loadChanels_returnsEmptyIfThereAreNoChannels() {
        // given
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
        // when
        sut.loadChannels()
        service.complete(with: .success([]))
        
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
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
        // when
        sut.loadChannels()
        service.complete(with: .success(loadedChannels))
        
        // then
        switch sut.loadChannelsResult {
        case .success(let gotChannels):
            XCTAssertEqual(gotChannels, expectedChannelItems)
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_loadChanels_returnsUnknownErrorOnUnknownError() {
        // given
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
        // when
        sut.loadChannels()
        service.complete(with: .failure(.unknown))
        
        // then
        switch sut.loadChannelsResult {
        case .failure(let receivedError):
            XCTAssertEqual(receivedError, .unknown, "Expected unknown error, got \(receivedError) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_loadChanels_returnsConnectivityErrorOnConnectivityError() {
        // given
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
        // when
        sut.loadChannels()
        service.complete(with: .failure(.connectivity))
        
        // then
        switch sut.loadChannelsResult {
        case .failure(let receivedError):
            XCTAssertEqual(receivedError, .connectivity, "Expected connectivity error, got \(receivedError) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_loadChanels_returnsInvalidDataErrorOnInvalidDataError() {
        // given
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
        // when
        sut.loadChannels()
        service.complete(with: .failure(.invalidData))
        
        // then
        switch sut.loadChannelsResult {
        case .failure(let receivedError):
            XCTAssertEqual(receivedError, .invalidData, "Expected connectivity error, got \(receivedError) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_createChannel_sendsLoadChannelsRequestOnSuccessfulChannelCreation() {
        // given
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
        // when
        sut.createChannel(withName: "channel name", description: "channel description")
        service.completeChannelCreation(with: .success(()))
        
        // then
        XCTAssertEqual(service.createChannelCallCount, 1)
        XCTAssertEqual(service.loadCallCount, 1)
    }
    
    func test_createChannel_doesNotSendLoadChannelsRequestOnFailedChannelCreation() {
        // given
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
        // when
        sut.createChannel(withName: "channel name", description: "channel description")
        service.completeChannelCreation(with: .failure(.unknown))
        
        // then
        XCTAssertEqual(service.createChannelCallCount, 1)
        XCTAssertEqual(service.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    
    private func makeChannel(with name: String, description: String) -> Channel {
        .init(id: UUID().uuidString, name: name, description: description)
    }
    
    private func makeChannelItem(with name: String) -> ChannelItem {
        .channel(name: name, isUnread: false)
    }
    
    final class ChannelsServiceStub: ChannelsServiceProtocol {
        private var completions = [(Result<[Channel], LoadChannelsError>) -> Void]()
        private var createChannelCompletions = [(Result<Void, LoadChannelsError>) -> Void]()
        
        var loadCallCount: Int {
            completions.count
        }
        
        var createChannelCallCount: Int {
            createChannelCompletions.count
        }
        
        func load(completion: @escaping (Result<[Channel], LoadChannelsError>) -> Void) {
            completions.append(completion)
        }
        
        func createChannel(withName name: String, description: String, completion: @escaping (Result<Void, LoadChannelsError>) -> Void) {
            createChannelCompletions.append(completion)
        }
        
        func complete(with result: Result<[Channel], LoadChannelsError>, at index: Int = 0) {
            completions[index](result)
        }
        
        func completeChannelCreation(with result: Result<Void, LoadChannelsError>, at index: Int = 0) {
            createChannelCompletions[index](result)
        }
    }
}

extension ChannelItem: Equatable {
    public static func == (lhs: ChannelItem, rhs: ChannelItem) -> Bool {
        switch (lhs, rhs) {
        case (.title, .title):
            return true
        case let (.channel(lhsName, lhsIsUnread), .channel(rhsName, rhsIsUnread)):
            return lhsName == rhsName && lhsIsUnread == rhsIsUnread
        default:
            return false
        }
    }
}
