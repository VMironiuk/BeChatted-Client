//
//  CreateChannelViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 23.05.2024.
//

import XCTest
import BeChatted

final class CreateChannelViewModelTests: XCTestCase {
    
    func test_init_doesNotSendCreateChannelRequest() {
        // given
        
        // when
        let (_, service) = makeSUT()
        
        // then
        XCTAssertEqual(service.createChannelCallCount, 0)
    }
    
    func test_createChannel_sendsCreateChannelRequest() {
        // given
        let (sut, service) = makeSUT()
        
        // when
        sut.createChannel(withName: "name", description: "description")
        
        // then
        XCTAssertEqual(service.createChannelCallCount, 1)
    }
    
    func test_createChannel_calledTwice_sendsCreateChannelRequestTwice() {
        // given
        let (sut, service) = makeSUT()
        
        // when
        sut.createChannel(withName: "name", description: "description")
        sut.createChannel(withName: "name", description: "description")
        
        // then
        XCTAssertEqual(service.createChannelCallCount, 2)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (CreateChannelViewModel, CreateChannelServiceSpy) {
        let service = CreateChannelServiceSpy()
        let sut = CreateChannelViewModel(service: service)
        
        trackForMemoryLeaks(service, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, service)
    }
    
    private final class CreateChannelServiceSpy: CreateChannelServiceProtocol {
        struct Message {
            let name: String
            let description: String
            let completion: (Result<Void, CreateChannelServiceError>) -> Void
        }
        
        private var messages = [Message]()
        
        var createChannelCallCount: Int {
            messages.count
        }
        
        func createChannel(
            withName name: String,
            description: String,
            completion: @escaping (Result<Void, CreateChannelServiceError>) -> Void
        ) {
            messages.append(.init(name: name, description: description, completion: completion))
        }
    }
}
