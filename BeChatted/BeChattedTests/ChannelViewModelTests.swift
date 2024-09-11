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
  
  func test_loadMessages_sendsLoadMessagesRequest() {
    let channelID = "CHANNEL_ID"
    let (sut, service) = makeSUT()
    
    sut.loadMessages(by: channelID)
    
    XCTAssertEqual(service.loadMessagesCallCount, 1)
  }
  
  func test_loadMessages_deliversServerErrorOnMessagingServiceServerError() {
    let (sut, service) = makeSUT()
    expect(sut, toCompleteWithError: .server, when: {
      service.complete(with: .server)
    })
  }
  
  func test_loadMessages_deliversInvalidDataErrorOnMessagingServiceInvalidDataError() {
    let (sut, service) = makeSUT()
    expect(sut, toCompleteWithError: .invalidData, when: {
      service.complete(with: .invalidData)
    })
  }
  
  func test_loadMessages_deliversInvalidResponseErrorOnMessagingServiceInvalidResponseError() {
    let (sut, service) = makeSUT()
    expect(sut, toCompleteWithError: .invalidResponse, when: {
      service.complete(with: .invalidResponse)
    })
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
  
  private func expect(
    _ sut: ChannelViewModel,
    toCompleteWithError expectedError: MessagingServiceError,
    when action: () -> Void,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let channelID = "CHANNEL_ID"
    let exp = expectation(description: "Wait for messages loading completion")
    
    let sub = sut.$status
      .dropFirst()
      .sink { value in
        switch value {
        case .failure(let receivedError):
          XCTAssertEqual(expectedError, receivedError)
        default:
          XCTFail("Expected \(expectedError), got \(value) instead")
        }
        exp.fulfill()
      }
    
    sut.loadMessages(by: channelID)
    
    action()
    
    wait(for: [exp], timeout: 1)
    sub.cancel()
  }
  
  private final class MessagingService: MessagingServiceProtocol {
    private var completions = [(Result<[MessageInfo], MessagingServiceError>) -> Void]()
    
    var loadMessagesCallCount: Int {
      completions.count
    }
    
    func loadMessages(
      by channelID: String,
      completion: @escaping (Result<[MessageInfo], MessagingServiceError>) -> Void
    ) {
      completions.append(completion)
    }
    
    func complete(with error: MessagingServiceError, at index: Int = 0) {
      completions[index](.failure(error))
    }
  }
}

extension MessagingServiceError: Equatable {
  public static func == (lhs: MessagingServiceError, rhs: MessagingServiceError) -> Bool {
    switch (lhs, rhs) {
    case (.server, .server): true
    case (.invalidData, .invalidData): true
    case (.invalidResponse, .invalidResponse): true
    case (.unknown(let lhsError as NSError), .unknown(let rhsError as NSError)):
      lhsError.code == rhsError.code && lhsError.domain == rhsError.domain
    default: false
    }
  }
}
