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
        XCTAssertEqual(service.loadChannelsCallCount, 0)
    }
    
    func test_loadChanels_returnsEmptyIfThereAreNoChannels() {
        // given
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
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
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
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
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
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
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
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
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
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
    
    func test_createChannel_sendsLoadChannelsRequestOnSuccessfulChannelCreation() {
        // given
        let service = ChannelsServiceStub()
        let sut = ChannelsViewModel(channelsService: service)
        
        // when
        sut.createChannel(withName: "channel name", description: "channel description")
        service.completeChannelCreation(with: .success(()))
        
        // then
        XCTAssertEqual(service.createChannelCallCount, 1)
        XCTAssertEqual(service.loadChannelsCallCount, 1)
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
        XCTAssertEqual(service.loadChannelsCallCount, 0)
    }
    
    // MARK: - Helpers
    
    private func makeChannel(with name: String, description: String) -> Channel {
        .init(id: UUID().uuidString, name: name, description: description)
    }
    
    private func makeChannelItem(with name: String) -> ChannelItem {
        .channel(name: name, isUnread: false)
    }
    
    final class ChannelsServiceStub: ChannelsServiceProtocol {
        private var loadChannelsCompletions = [(Result<[Channel], ChannelsServiceError>) -> Void]()
        private var createChannelCompletions = [(Result<Void, ChannelsServiceError>) -> Void]()
        
        var loadChannelsCallCount: Int {
            loadChannelsCompletions.count
        }
        
        var createChannelCallCount: Int {
            createChannelCompletions.count
        }
        
        func loadChannels(completion: @escaping (Result<[Channel], ChannelsServiceError>) -> Void) {
            loadChannelsCompletions.append(completion)
        }
        
        func createChannel(withName name: String, description: String, completion: @escaping (Result<Void, ChannelsServiceError>) -> Void) {
            createChannelCompletions.append(completion)
        }
        
        func completeChannelsLoading(with result: Result<[Channel], ChannelsServiceError>, at index: Int = 0) {
            loadChannelsCompletions[index](result)
        }
        
        func completeChannelCreation(with result: Result<Void, ChannelsServiceError>, at index: Int = 0) {
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
