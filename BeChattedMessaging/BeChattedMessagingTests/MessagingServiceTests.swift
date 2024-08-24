//
//  MessagingServiceTests.swift
//  BeChattedMessagingTests
//
//  Created by Volodymyr Myroniuk on 22.08.2024.
//

import XCTest

import Combine

protocol WebSocketClientProtocol {
  func connect()
  func on(_ event: String, completion: @escaping ([Any]) -> Void)
  func emit(
    _ event: String,
    _ item1: String,
    _ item2: String,
    _ item3: String,
    _ item4: String,
    _ item5: String,
    _ item6: String
  )
}

struct MessagingService {
  typealias MessageData = (
    body: String,
    userID: String,
    channelID: String,
    userName: String,
    userAvatar: String,
    userAvatarColor: String,
    id: String,
    timeStamp: String
  )
  
  struct Message {
    let body: String
    let userID: String
    let channelID: String
    let userName: String
    let userAvatar: String
    let userAvatarColor: String
  }
  
  enum Event: String {
    case messageCreated
    case userTypingUpdate
    case newMessage
  }
  
  private let webSocketClient: WebSocketClientProtocol
  
  let newMessage = PassthroughSubject<MessageData, Never>()
  
  init(webSocketClient: WebSocketClientProtocol) {
    self.webSocketClient = webSocketClient
    
    webSocketClient.connect()
    webSocketClient.on(Event.messageCreated.rawValue) { [weak newMessage] messageData in
      guard let messageFields = messageData as? [String], messageFields.count == 8 else {
        return
      }
      newMessage?.send(
        (
          body: messageFields[0],
          userID: messageFields[1],
          channelID: messageFields[2],
          userName: messageFields[3],
          userAvatar: messageFields[4],
          userAvatarColor: messageFields[5],
          id: messageFields[6],
          timeStamp: messageFields[7]
        )
      )
    }
    
    webSocketClient.on(Event.userTypingUpdate.rawValue) { _ in }
  }
  
  func sendMessage(_ message: Message) {
    webSocketClient.emit(
      Event.newMessage.rawValue,
      message.body,
      message.userID,
      message.channelID,
      message.userName,
      message.userAvatar,
      message.userAvatarColor
    )
  }
}

final class MessagingServiceTests: XCTestCase {
  func test_init_setsUpWebSocketClient() {
    let (_, webSocketClient) = makeSUT()
    
    XCTAssertEqual(webSocketClient.connectCallCount, 1)
    XCTAssertTrue(webSocketClient.onMessages.map { $0.event }.contains(MessagingService.Event.messageCreated.rawValue))
    XCTAssertTrue(webSocketClient.onMessages.map { $0.event }.contains(MessagingService.Event.userTypingUpdate.rawValue))
  }
  
  func test_sendMessage_emitsNewMessage() {
    let message = MessagingService.Message(
      body: "message body",
      userID: "007",
      channelID: "777",
      userName: "James",
      userAvatar: "user avatar",
      userAvatarColor: "user avatar color"
    )
    let (sut, webSocketClient) = makeSUT()

    sut.sendMessage(message)
    
    XCTAssertEqual(webSocketClient.emitCallCount, 1)
    XCTAssertEqual(webSocketClient.emitMessages[0].event, MessagingService.Event.newMessage.rawValue)
    XCTAssertEqual(webSocketClient.emitMessages[0].item1, message.body)
    XCTAssertEqual(webSocketClient.emitMessages[0].item2, message.userID)
    XCTAssertEqual(webSocketClient.emitMessages[0].item3, message.channelID)
    XCTAssertEqual(webSocketClient.emitMessages[0].item4, message.userName)
    XCTAssertEqual(webSocketClient.emitMessages[0].item5, message.userAvatar)
    XCTAssertEqual(webSocketClient.emitMessages[0].item6, message.userAvatarColor)
  }
  
  func test_webSocketClient_onMethodCompletion_publishesNewMessage() {
    let body = "MESSAGE_BODY"
    let userID = "USER_ID"
    let channelID = "CHANNEL_ID"
    let userName = "USER_NAME"
    let userAvatar = "USER_AVATAR"
    let userAvatarColor = "USER_AVATAR_COLOR"
    let id = "ID"
    let timeStamp = "TIMESTAMP"
    let exp = expectation(description: "Waiting for a new message")
    let (sut, webSocketClient) = makeSUT()
    
    let sub = sut.newMessage.sink { newMessageData in
      XCTAssertEqual(newMessageData.body, body)
      XCTAssertEqual(newMessageData.userID, userID)
      XCTAssertEqual(newMessageData.channelID, channelID)
      XCTAssertEqual(newMessageData.userName, userName)
      XCTAssertEqual(newMessageData.userAvatar, userAvatar)
      XCTAssertEqual(newMessageData.userAvatarColor, userAvatarColor)
      XCTAssertEqual(newMessageData.id, id)
      XCTAssertEqual(newMessageData.timeStamp, timeStamp)

      exp.fulfill()
    }
    webSocketClient.completeOn(with: [body, userID, channelID, userName, userAvatar, userAvatarColor, id, timeStamp])
        
    wait(for: [exp], timeout: 1)
    sub.cancel()

  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (MessagingService, WebSocketClientSpy) {
    let webSocketClient = WebSocketClientSpy()
    let sut = MessagingService(webSocketClient: webSocketClient)
    
    trackForMemoryLeaks(webSocketClient, file: file, line: line)
    
    return (sut, webSocketClient)
  }
  
  private final class WebSocketClientSpy: WebSocketClientProtocol {
    struct OnMessage {
      let event: String
      let completion: ([Any]) -> Void
    }
    
    struct EmitMessage {
      let event: String
      let item1: String
      let item2: String
      let item3: String
      let item4: String
      let item5: String
      let item6: String
    }
    
    private(set) var onMessages = [OnMessage]()
    private(set) var emitMessages = [EmitMessage]()
    private(set) var connectCallCount = 0
    var emitCallCount: Int {
      emitMessages.count
    }
    
    func connect() {
      connectCallCount += 1
    }
    
    func on(_ event: String, completion: @escaping ([Any]) -> Void) {
      onMessages.append(OnMessage(event: event, completion: completion))
    }
    
    func emit(
      _ event: String,
      _ item1: String,
      _ item2: String,
      _ item3: String,
      _ item4: String,
      _ item5: String,
      _ item6: String
    ) {
      emitMessages.append(
        EmitMessage(
          event: event,
          item1: item1,
          item2: item2,
          item3: item3,
          item4: item4,
          item5: item5,
          item6: item6
        )
      )
    }
    
    func completeOn(with newMessageData: [String], at index: Int = 0) {
      onMessages[index].completion(newMessageData)
    }
  }
}
