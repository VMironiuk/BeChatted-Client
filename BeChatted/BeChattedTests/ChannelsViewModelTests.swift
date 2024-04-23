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

enum ChannelsLoaderError: Error {
    case unknown
    case connectivity
    case invalidData
}

protocol ChannelsLoaderProtocol {
    func load(completion: @escaping (Result<[Channel], ChannelsLoaderError>) -> Void)
}

final class ChannelsLoaderStub: ChannelsLoaderProtocol {
    private(set) var loadCallCount = 0
    
    func load(completion: @escaping (Result<[Channel], ChannelsLoaderError>) -> Void) {
        loadCallCount += 1
    }
}

final class ChannelsViewModel {
    private let loader: ChannelsLoaderProtocol
    
    init(loader: ChannelsLoaderProtocol) {
        self.loader = loader
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
}
