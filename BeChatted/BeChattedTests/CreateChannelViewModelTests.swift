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
  
  // MARK: - Helpers
  
  private func makeSUT(
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (CreateChannelViewModel, CreateChannelServiceSpy) {
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
    }
    
    private(set) var messages = [Message]()
    
    var createChannelCallCount: Int {
      messages.count
    }
    
    func addChannel(withName name: String, description: String) {
      messages.append(Message(name: name, description: description))
    }
  }
}
