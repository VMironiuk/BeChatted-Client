//
//  ChannelViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 05.09.2024.
//

import BeChatted
import Combine
import XCTest

final class ChannelViewModelTests: XCTestCase {
  func test_init_doesNotLoadMessages() {
    let (_, service) = makeSUT()
    
    XCTAssertEqual(service.loadMessagesCallCount, 0)
  }
  
  func test_loadMessages_sendsLoadMessagesRequest() {
    let (sut, service) = makeSUT()
    
    sut.loadMessages()
    
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
  
  func test_loadMessages_deliversUnknownErrorOnMessagingServiceUnknownError() {
    let underlyingError = NSError(domain: "any domain", code: 42)
    let (sut, service) = makeSUT()
    expect(sut, toCompleteWithError: .unknown(underlyingError), when: {
      service.complete(with: .unknown(underlyingError))
    })
  }
  
  func test_loadMessages_deliversEmptyMessagesOnMessagingServiceEmptyMessages() {
    let expectedMessages = [MessageInfo]()
    let (sut, service) = makeSUT()
    expect(sut, toCompleteWithMessages: [], when: {
      service.complete(with: expectedMessages)
    })
  }
  
  func test_loadMessages_deliversMessagesOnMessagingServiceReturnedMessages() {
    let expectedMessages = anyMessages()
    let (sut, service) = makeSUT()
    expect(sut, toCompleteWithMessages: expectedMessages, when: {
      service.complete(with: expectedMessages)
    })
  }
  
  func test_sendMessage_deliversMessagePayloadToMessagingService() {
    let messagePayload = anyMessagePayload()
    let (sut, service) = makeSUT()
    
    sut.sendMessage(messagePayload)
    
    XCTAssertEqual(service.messagePayloads[0], messagePayload)
  }
  
  func test_sut_observesNewMessage() {
    let newMessage = anyNewMessage()
    let exp = expectation(description: "Wait for new message")
    let (sut, service) = makeSUT()
    let sub = sut.$status
      .dropFirst()
      .sink { result in
        switch result {
        case .success(let messages):
          XCTAssertEqual(messages[0].channelId, newMessage.channelID)
          XCTAssertEqual(messages[0].id, newMessage.id)
          XCTAssertEqual(messages[0].messageBody, newMessage.body)
          XCTAssertEqual(messages[0].timeStamp, newMessage.timeStamp)
          XCTAssertEqual(messages[0].userAvatar, newMessage.userAvatar)
          XCTAssertEqual(messages[0].userAvatarColor, newMessage.userAvatarColor)
          XCTAssertEqual(messages[0].userId, newMessage.userID)
          XCTAssertEqual(messages[0].userName, newMessage.userName)
        case .failure:
          XCTFail("Expected updated messages, got \(result) instead")
        }
        exp.fulfill()
      }
    
    service.newMessage.send(newMessage)
    
    wait(for: [exp], timeout: 1)
    sub.cancel()
  }
  
  func test_sut_addsNewMessageToExistingMessages() {
    let newMessage = anyNewMessage()
    let messages = anyMessages()
    let exp = expectation(description: "Wait for new message")
    let (sut, service) = makeSUT()
    service.newMessage.send(messages[0].tuple)
    service.newMessage.send(messages[1].tuple)
    let sub = sut.$status
      .dropFirst()
      .sink { result in
        switch result {
        case .success(let receivedMessages):
          XCTAssertEqual(receivedMessages[0], messages[0])
          XCTAssertEqual(receivedMessages[1], messages[1])
          XCTAssertEqual(receivedMessages[2].channelId, newMessage.channelID)
          XCTAssertEqual(receivedMessages[2].id, newMessage.id)
          XCTAssertEqual(receivedMessages[2].messageBody, newMessage.body)
          XCTAssertEqual(receivedMessages[2].timeStamp, newMessage.timeStamp)
          XCTAssertEqual(receivedMessages[2].userAvatar, newMessage.userAvatar)
          XCTAssertEqual(receivedMessages[2].userAvatarColor, newMessage.userAvatarColor)
          XCTAssertEqual(receivedMessages[2].userId, newMessage.userID)
          XCTAssertEqual(receivedMessages[2].userName, newMessage.userName)
        case .failure:
          XCTFail("Expected updated messages, got \(result) instead")
        }
        exp.fulfill()
      }
    
    service.newMessage.send(newMessage)
    
    wait(for: [exp], timeout: 1)
    sub.cancel()
  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    channelItem: ChannelItem = ChannelItem(id: "1", name: "name", description: "description"),
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (ChannelViewModel, MessagingService) {
    let service = MessagingService()
    let sut = ChannelViewModel(
      currentUser: User(id: "USER_ID", name: "USER_NAME"),
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
    
    sut.loadMessages()
    
    action()
    
    wait(for: [exp], timeout: 1)
    sub.cancel()
  }
  
  private func expect(
    _ sut: ChannelViewModel,
    toCompleteWithMessages expectedMessages: [MessageInfo],
    when action: () -> Void,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let exp = expectation(description: "Wait for messages loading completion")
    
    let sub = sut.$status
      .dropFirst()
      .sink { value in
        switch value {
        case .success(let receivedMessages):
          XCTAssertEqual(expectedMessages, receivedMessages, file: file, line: line)
        default:
          XCTFail("Expected to get messages, got \(value) instead", file: file, line: line)
        }
        exp.fulfill()
      }
    
    sut.loadMessages()
    
    action()
    
    wait(for: [exp], timeout: 1)
    sub.cancel()
  }
  
  private func anyMessages() -> [MessageInfo] {
    [
      MessageInfo(
        id: "1",
        messageBody: "msg body",
        userId: "11",
        channelId: "111",
        userName: "user name",
        userAvatar: "avatar",
        userAvatarColor: "avatar color",
        timeStamp: "now"
      ),
      MessageInfo(
        id: "2",
        messageBody: "msg body",
        userId: "22",
        channelId: "222",
        userName: "user name",
        userAvatar: "avatar",
        userAvatarColor: "avatar color",
        timeStamp: "now"
      )
    ]
  }
  
  private func anyMessagePayload() -> MessagePayload {
    MessagePayload(
      body: "message body",
      userID: "user ID",
      channelID: "channel ID",
      userName: "user name",
      userAvatar: "avatar",
      userAvatarColor: "avatar color"
    )
  }
  
  private func anyNewMessage() -> (
    body: String,
    userID: String,
    channelID: String,
    userName: String,
    userAvatar: String,
    userAvatarColor: String,
    id: String,
    timeStamp: String
  ) {
    (
      body: "message body",
      userID: "user ID",
      channelID: "chanel ID",
      userName: "a name",
      userAvatar: "avatar",
      userAvatarColor: "avatar color",
      id: "ID",
      timeStamp: "today"
    )
  }
  
  private final class MessagingService: MessagingServiceProtocol {
    private var completions = [(Result<[MessageInfo], MessagingServiceError>) -> Void]()
    private(set) var messagePayloads = [MessagePayload]()
    
    var loadMessagesCallCount: Int {
      completions.count
    }
    
    let newMessage = PassthroughSubject<MessageData, Never>()
    
    func loadMessages(
      by channelID: String,
      completion: @escaping (Result<[MessageInfo], MessagingServiceError>) -> Void
    ) {
      completions.append(completion)
    }
    
    func sendMessage(_ message: MessagePayload) {
      messagePayloads.append(message)
    }
    
    func complete(with error: MessagingServiceError, at index: Int = 0) {
      completions[index](.failure(error))
    }
    
    func complete(with messages: [MessageInfo], at index: Int = 0) {
      completions[index](.success(messages))
    }
  }
}

extension MessageInfo {
  var tuple: (
    body: String,
    userID: String,
    channelID: String,
    userName: String,
    userAvatar: String,
    userAvatarColor: String,
    id: String,
    timeStamp: String
  ) {
    (
      body: messageBody,
      userID: userId,
      channelID: channelId,
      userName: userName,
      userAvatar: userAvatar,
      userAvatarColor: userAvatarColor,
      id: id,
      timeStamp: timeStamp
    )
  }
}
