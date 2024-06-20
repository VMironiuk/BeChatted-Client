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
        sut.createChannel()
        
        // then
        XCTAssertEqual(service.createChannelCallCount, 1)
    }
    
    func test_createChannel_calledTwice_sendsCreateChannelRequestTwice() {
        // given
        let (sut, service) = makeSUT()
        
        // when
        sut.createChannel()
        sut.createChannel()
        
        // then
        XCTAssertEqual(service.createChannelCallCount, 2)
    }
    
    func test_createChannel_deliversSuccessOnSuccessfulCreateChannelResponse() {
        let (sut, service) = makeSUT()
        expect(sut, toBeInState: .success, when: {
            service.complete(with: .success(()))
        })
    }
    
    func test_createChannel_deliversServerErrorOnServerErrorCreateChannelResponse() {
        let (sut, service) = makeSUT()
        expect(sut, toBeInState: .failure(.server), when: {
            service.complete(with: .failure(.server))
        })
    }
    
    func test_createChannel_deliversConnectivityErrorOnConnectivityErrorCreateChannelResponse() {
        let (sut, service) = makeSUT()
        expect(sut, toBeInState: .failure(.connectivity), when: {
            service.complete(with: .failure(.connectivity))
        })
    }
    
    func test_createChannel_deliversUnknownErrorOnUnknownErrorCreateChannelResponse() {
        let (sut, service) = makeSUT()
        expect(sut, toBeInState: .failure(.unknown), when: {
            service.complete(with: .failure(.unknown))
        })
    }
    
    func test_stateTransitions_forHappyPath() {
        let (sut, service) = makeSUT()
        XCTAssertEqual(sut.state, .ready, "Expected sut state to be ready, got \(sut.state) instead")
        
        sut.createChannel()
        XCTAssertEqual(sut.state, .inProgress, "Expected sut state to be inProgress, got \(sut.state) instead")
        
        let exp = expectation(description: "Wait for channel creation completion")
        let sub = sut.$state
            .sink { result in
                if result == .success {
                    exp.fulfill()
                }
            }
        
        service.complete(with: .success(()))
        
        wait(for: [exp], timeout: 1)
        sub.cancel()
    }
    
    func test_stateTransitions_forSadPath() {
        let (sut, service) = makeSUT()
        XCTAssertEqual(sut.state, .ready, "Expected sut state to be ready, got \(sut.state) instead")
        
        sut.createChannel()
        XCTAssertEqual(sut.state, .inProgress, "Expected sut state to be inProgress, got \(sut.state) instead")
        
        let exp = expectation(description: "Wait for channel creation completion")
        let sub = sut.$state
            .sink { result in
                if result == .failure(.unknown) {
                    exp.fulfill()
                }
            }
        
        service.complete(with: .failure(.unknown))
        
        wait(for: [exp], timeout: 1)
        sub.cancel()
    }

    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (CreateChannelViewModel, CreateChannelServiceSpy) {
        let service = CreateChannelServiceSpy()
        let sut = CreateChannelViewModel(service: service)
        
        trackForMemoryLeaks(service, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, service)
    }
    
    private func expect(
        _ sut: CreateChannelViewModel,
        toBeInState state: CreateChannelViewModelState,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: Int = #line
    ) {
        // given
        let exp = expectation(description: "Wait for channel creation completion")
        let sub = sut.$state
            .sink { result in
                if result == state {
                    exp.fulfill()
                }
            }
        
        // when
        sut.createChannel()
        
        action()
        
        // then
        wait(for: [exp], timeout: 1)
        sub.cancel()
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
        
        func complete(with result: Result<Void, CreateChannelServiceError>, at index: Int = 0) {
            messages[index].completion(result)
        }
    }
}
