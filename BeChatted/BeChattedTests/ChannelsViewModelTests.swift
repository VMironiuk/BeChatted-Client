//
//  ChannelsViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 23.04.2024.
//

import XCTest

struct Channel {
    let id: String
    let name: String
    let description: String
}

enum LoadChannelsError: Error {
    case unknown
    case connectivity
    case invalidData
}

protocol ChannelsLoaderProtocol {
    func load(completion: @escaping (Result<[Channel], LoadChannelsError>) -> Void)
}

final class ChannelsLoaderStub: ChannelsLoaderProtocol {
    private var completions = [(Result<[Channel], LoadChannelsError>) -> Void]()
    
    var loadCallCount: Int {
        completions.count
    }
    
    func load(completion: @escaping (Result<[Channel], LoadChannelsError>) -> Void) {
        completions.append(completion)
    }
    
    func complete(with result: Result<[Channel], LoadChannelsError>, at index: Int = 0) {
        completions[index](result)
    }
}

final class ChannelsViewModel {
    private let loader: ChannelsLoaderProtocol
    
    var loadChannelsResult: Result<[Channel], LoadChannelsError> = .success([])
    
    init(loader: ChannelsLoaderProtocol) {
        self.loader = loader
    }
    
    func loadChannels() {
        loader.load { [weak self] result in
            self?.loadChannelsResult = result
        }
    }
}

final class ChannelsViewModelTests: XCTestCase {
    
    func test_init_doesNotSendLoadRequest() {
        // given
        
        // when
        let loader = ChannelsLoaderStub()
        _ = ChannelsViewModel(loader: loader)
        
        // then
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_load_returnsEmptyIfThereAreNoChannels() {
        // given
        let loader = ChannelsLoaderStub()
        let sut = ChannelsViewModel(loader: loader)
        
        // when
        sut.loadChannels()
        loader.complete(with: .success([]))
        
        // then
        switch sut.loadChannelsResult {
        case .success(let channels):
            XCTAssertTrue(channels.isEmpty, "Expected empty channels, got \(channels) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_load_returnsChannelsIfThereAreChannels() {
        // given
        let expectedChannels = [makeChannel(with: "A", description: "AAA"), makeChannel(with: "B", description: "BBB")]
        let loader = ChannelsLoaderStub()
        let sut = ChannelsViewModel(loader: loader)
        
        // when
        sut.loadChannels()
        loader.complete(with: .success(expectedChannels))
        
        // then
        switch sut.loadChannelsResult {
        case .success(let gotChannels):
            XCTAssertEqual(gotChannels, expectedChannels)
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_load_returnsUnknownErrorOnUnknownError() {
        // given
        let loader = ChannelsLoaderStub()
        let sut = ChannelsViewModel(loader: loader)
        
        // when
        sut.loadChannels()
        loader.complete(with: .failure(.unknown))
        
        // then
        switch sut.loadChannelsResult {
        case .failure(let receivedError):
            XCTAssertEqual(receivedError, .unknown, "Expected unknown error, got \(receivedError) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_load_returnsConnectivityErrorOnConnectivityError() {
        // given
        let loader = ChannelsLoaderStub()
        let sut = ChannelsViewModel(loader: loader)
        
        // when
        sut.loadChannels()
        loader.complete(with: .failure(.connectivity))
        
        // then
        switch sut.loadChannelsResult {
        case .failure(let receivedError):
            XCTAssertEqual(receivedError, .connectivity, "Expected connectivity error, got \(receivedError) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }
    
    func test_load_returnsInvalidDataErrorOnInvalidDataError() {
        // given
        let loader = ChannelsLoaderStub()
        let sut = ChannelsViewModel(loader: loader)
        
        // when
        sut.loadChannels()
        loader.complete(with: .failure(.invalidData))
        
        // then
        switch sut.loadChannelsResult {
        case .failure(let receivedError):
            XCTAssertEqual(receivedError, .invalidData, "Expected connectivity error, got \(receivedError) instead")
        default: XCTFail("Expected empty result, got \(sut.loadChannelsResult) instead")
        }
    }

    // MARK: - Helpers
    
    private func makeChannel(with name: String, description: String) -> Channel {
        .init(id: UUID().uuidString, name: name, description: description)
    }
}

extension Channel: Equatable {}
