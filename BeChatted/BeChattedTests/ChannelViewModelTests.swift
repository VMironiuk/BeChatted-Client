//
//  ChannelViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 05.09.2024.
//

import BeChatted
import XCTest

final class ChannelViewModelTests: XCTestCase {
  func test_init_doesNotLoadMessages() {
    let (_, service) = makeSUT()
    
    XCTAssertEqual(service.loadMessagesCallCount, 0)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    channelItem: ChannelItem = ChannelItem(id: "1", name: "name", description: "description"),
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (ChannelViewModel, MessagingService) {
    let service = MessagingService()
    let sut = ChannelViewModel(
      channelItem: channelItem,
      messagingService: service
    )
    
    trackForMemoryLeaks(service, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    
    return (sut, service)
  }
  
  private final class MessagingService: MessagingServiceProtocol {
    private(set) var loadMessagesCallCount = 0
    
    func loadMessages(
      by channelID: String,
      completion: @escaping (Result<[MessageInfo], MessagingServiceError>) -> Void
    ) {
      loadMessagesCallCount += 1
    }
  }
}
