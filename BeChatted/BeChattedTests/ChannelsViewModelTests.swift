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

    func test_loadChannels_returnsChannelsIfThereAreChannels() {
        // given
        let loadedChannels = [
            makeChannel(withId: "id=a", name: "A", description: "AAA"),
            makeChannel(withId: "id=b", name: "B", description: "BBB")
        ]
        let expectedChannelItems = [makeChannelItem(withId: "id=a", name: "A"), makeChannelItem(withId: "id=b", name: "B")]
        let (sut, service) = makeSUT()
        
        let exp = expectation(description: "Wait for channels loading completion")
        let sub = sut.$loadChannelsResult
            .sink { result in
                switch result {
                case .success(let gotChannels):
                    if gotChannels == expectedChannelItems {
                        exp.fulfill()
                    }
                case .failure(let error):
                    XCTFail("Expected success, got \(error) instead")
                }
            }

        // when
        sut.loadChannels()
        service.completeChannelsLoading(with: .success(loadedChannels))

        // then
        wait(for: [exp], timeout: 1)
        sub.cancel()
    }
    
    func test_loadChanels_returnsUnknownErrorOnUnknownError() {
        // given
        let (sut, service) = makeSUT()
        
        let exp = expectation(description: "Wait for channels loading completion")
        let sub = sut.$loadChannelsResult
            .sink { result in
                switch result {
                case .failure(let error):
                    if error == .unknown {
                        exp.fulfill()
                    }
                default:
                    break
                }
            }
        
        // when
        sut.loadChannels()
        service.completeChannelsLoading(with: .failure(.unknown))
        
        // then
        wait(for: [exp], timeout: 1)
        sub.cancel()
    }
    
    func test_loadChanels_returnsConnectivityErrorOnConnectivityError() {
        // given
        let (sut, service) = makeSUT()
        
        let exp = expectation(description: "Wait for channels loading completion")
        let sub = sut.$loadChannelsResult
            .sink { result in
                switch result {
                case .failure(let error):
                    if error == .connectivity {
                        exp.fulfill()
                    }
                default:
                    break
                }
            }
        
        // when
        sut.loadChannels()
        service.completeChannelsLoading(with: .failure(.connectivity))
        
        // then
        wait(for: [exp], timeout: 1)
        sub.cancel()
    }
    
    func test_loadChanels_returnsInvalidDataErrorOnInvalidDataError() {
        // given
        let (sut, service) = makeSUT()
        
        let exp = expectation(description: "Wait for channels loading completion")
        let sub = sut.$loadChannelsResult
            .sink { result in
                switch result {
                case .failure(let error):
                    if error == .invalidData {
                        exp.fulfill()
                    }
                default:
                    break
                }
            }
        
        // when
        sut.loadChannels()
        service.completeChannelsLoading(with: .failure(.invalidData))
        
        // then
        wait(for: [exp], timeout: 1)
        sub.cancel()
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (ChannelsViewModel, ChannelsLoadingServiceStub) {
        let service = ChannelsLoadingServiceStub()
        let sut = ChannelsViewModel(channelsLoadingService: service)
        
        trackForMemoryLeaks(service, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, service)
    }
    
    private func makeChannel(withId id: String, name: String, description: String) -> Channel {
        .init(id: id, name: name, description: description)
    }
    
    private func makeChannelItem(withId id: String, name: String) -> ChannelItem {
        .init(id: id, name: name)
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
