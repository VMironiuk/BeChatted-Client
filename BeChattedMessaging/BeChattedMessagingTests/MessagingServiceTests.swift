//
//  MessagingServiceTests.swift
//  BeChattedMessagingTests
//
//  Created by Volodymyr Myroniuk on 22.08.2024.
//

import XCTest
import BeChattedMessaging

final class MessagingServiceTests: XCTestCase {
  func test_init_setsUpWebSocketClient() {
    let (_, _, webSocketClient) = makeSUT()
    
    XCTAssertEqual(webSocketClient.connectCallCount, 1)
    XCTAssertTrue(webSocketClient.onMessages.map { $0.event }.contains(MessagingService.Event.messageCreated.rawValue))
  }
  
  func test_init_doesNotSendRequests() {
    let (_, httpClient, _) = makeSUT()
    
    XCTAssertEqual(httpClient.requestedURLs, [])
    XCTAssertEqual(httpClient.httpMethods, [])
    XCTAssertEqual(httpClient.contentTypes, [])
    XCTAssertEqual(httpClient.authTokens, [])
  }
  
  func test_sendMessage_emitsNewMessage() {
    let message = anyMessagePayload()
    let (sut, _, webSocketClient) = makeSUT()

    sut.sendMessage(message)
    
    XCTAssertEqual(webSocketClient.emitMessageCallCount, 1)
    XCTAssertEqual(webSocketClient.emitMessages[0].event, MessagingService.Event.newMessage.rawValue)
    XCTAssertEqual(webSocketClient.emitMessages[0].item1, message.body)
    XCTAssertEqual(webSocketClient.emitMessages[0].item2, message.userID)
    XCTAssertEqual(webSocketClient.emitMessages[0].item3, message.channelID)
    XCTAssertEqual(webSocketClient.emitMessages[0].item4, message.userName)
    XCTAssertEqual(webSocketClient.emitMessages[0].item5, message.userAvatar)
    XCTAssertEqual(webSocketClient.emitMessages[0].item6, message.userAvatarColor)
  }
  
  func test_sendUserStartTyping_emitsUserStartTyping() {
    let userName = "some-username"
    let channelID = "some-channel-id"
    let (sut, _, webSocketClient) = makeSUT()
    
    sut.sendUserStartTyping(userName, channelID: channelID)
    
    XCTAssertEqual(webSocketClient.emitUserStartTypingCallCount, 1)
    XCTAssertEqual(webSocketClient.emitUserStartTypingMessages[0].event, MessagingService.Event.startType.rawValue)
    XCTAssertEqual(webSocketClient.emitUserStartTypingMessages[0].item1, userName)
    XCTAssertEqual(webSocketClient.emitUserStartTypingMessages[0].item2, channelID)
  }
  
  func test_sendUserStopTyping_emitsUserStopTyping() {
    let userName = "some-username"
    let (sut, _, webSocketClient) = makeSUT()
    
    sut.sendUserStopTyping(userName)
    
    XCTAssertEqual(webSocketClient.emitUserStopTypingCallCount, 1)
    XCTAssertEqual(webSocketClient.emitUserStopTypingMessages[0].event, MessagingService.Event.stopType.rawValue)
    XCTAssertEqual(webSocketClient.emitUserStopTypingMessages[0].item1, userName)
  }
  
  func test_webSocketClient_onMethodCompletion_publishesNewMessage() {
    let messageData = anyMessageData()
    let exp = expectation(description: "Waiting for a new message")
    let (sut, _, webSocketClient) = makeSUT()
    
    let sub = sut.newMessage.sink { newMessageData in
      XCTAssertEqual(newMessageData.body, messageData.body)
      XCTAssertEqual(newMessageData.userID, messageData.userID)
      XCTAssertEqual(newMessageData.channelID, messageData.channelID)
      XCTAssertEqual(newMessageData.userName, messageData.userName)
      XCTAssertEqual(newMessageData.userAvatar, messageData.userAvatar)
      XCTAssertEqual(newMessageData.userAvatarColor, messageData.userAvatarColor)
      XCTAssertEqual(newMessageData.id, messageData.id)
      XCTAssertEqual(newMessageData.timeStamp, messageData.timeStamp)

      exp.fulfill()
    }
    webSocketClient.completeOn(
      with: [
        messageData.body,
        messageData.userID,
        messageData.channelID,
        messageData.userName,
        messageData.userAvatar,
        messageData.userAvatarColor,
        messageData.id,
        messageData.timeStamp
      ]
    )
        
    wait(for: [exp], timeout: 1)
    sub.cancel()
  }
  
  func test_loadMessages_callsHTTPClientPerform() {
    let channelID = "CHANNEL_ID"
    let (sut, httpClient, _) = makeSUT()
    
    sut.loadMessages(by: channelID) { _ in }
    
    XCTAssertEqual(httpClient.performCallCount, 1)
  }
  
  func test_loadMessages_deliversServerErrorOn500HTTPResponse() {
    let (sut, httpClient, _) = makeSUT()
    expect(sut, toCompleteWithError: .server, when: {
      httpClient.completeMessagesLoading(with: 500)
    })
  }
  
  func test_loadMessages_deliversInvalidDataErrorOn200HTTPResponseButInvalidData() {
    let (sut, httpClient, _) = makeSUT()
    expect(sut, toCompleteWithError: .invalidData, when: {
      httpClient.completeMessagesLoading(with: "invalid data".data(using: .utf8))
    })
  }
  
  func test_loadMessages_deliversInvalidResponseErrorOnNon200And500HTTPResponse() {
    let (sut, httpClient, _) = makeSUT()
    expect(sut, toCompleteWithError: .invalidResponse, when: {
      httpClient.completeMessagesLoading(with: 404)
    })
  }
  
  func test_loadMessages_deliversUnknownErrorOnFailedRequestPerforming() {
    let (sut, httpClient, _) = makeSUT()
    let underlyingError = NSError(domain: "some domain", code: 42)
    expect(sut, toCompleteWithError: .unknown(underlyingError), when: {
      httpClient.completeMessagesLoading(with: underlyingError)
    })
  }
  
  func test_loadMessages_deliversMessages() {
    let channelID = "CHANNEL_ID"
    let expectedMessages = anyMessageInfos()
    let exp = expectation(description: "Wait for messages loading")
    let (sut, httpClient, _) = makeSUT()
    
    sut.loadMessages(by: channelID) { result in
      switch result {
      case .success(let receivedMessages):
        XCTAssertEqual(receivedMessages, expectedMessages)
      default:
        XCTFail("Expected messages to be loaded, got \(result) instead")
      }
      exp.fulfill()
    }
    
    httpClient.completeMessagesLoading(with: try? JSONEncoder().encode(expectedMessages))
    wait(for: [exp], timeout: 1)
  }
  
  func test_loadMessages_sendsLoadMessagesRequestOnURLWithChannelID() {
    let channelID = "expected channel id"
    let (sut, httpClient, _) = makeSUT()
    
    sut.loadMessages(by: channelID) { _ in }
    
    XCTAssertEqual(httpClient.requestedURLs[0].lastPathComponent, channelID)
  }

  func test_loadMessages_sendsLoadMessagesRequestByURLTwice() {
    let channelID = "CHANNEL_ID"
    let baseURL = anyURL()
    let expectedURL = anyURL(with: channelID)
    let (sut, httpClient, _) = makeSUT(url: baseURL)
    
    sut.loadMessages(by: channelID) { _ in }
    sut.loadMessages(by: channelID) { _ in }
    
    XCTAssertEqual(httpClient.requestedURLs, [expectedURL, expectedURL])
  }
  
  func test_loadMessages_sendsLoadMessagesRequestAsGETMethod() {
    let (sut, httpClient, _) = makeSUT()
    
    sut.loadMessages(by: "CHANNEL_ID") { _ in }
    
    XCTAssertEqual(httpClient.httpMethods, ["GET"])
  }
  
  func test_loadMessages_sendsLoadMessagesRequestAsApplicationJSONContentType() {
    let (sut, httpClient, _) = makeSUT()
    
    sut.loadMessages(by: "CHANNEL_ID") { _ in }
    
    XCTAssertEqual(httpClient.contentTypes, ["application/json"])
  }
  
  func test_loadMessages_sendsLoadMessagesRequestWithAuthToken() {
    let anyAuthToken = anyAuthToken()
    let (sut, httpClient, _) = makeSUT(authToken: anyAuthToken)
    
    sut.loadMessages(by: "CHANNEL_ID") { _ in }
    
    XCTAssertEqual(httpClient.authTokens, ["Bearer \(anyAuthToken)"])
  }

  // MARK: - Helpers
  
  private func makeSUT(
    url: URL = URL(string: "http://any-url.com")!,
    authToken: String = "any auth token",
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (MessagingService, HTTPClientSpy, WebSocketClientSpy) {
    let httpClient = HTTPClientSpy()
    let webSocketClient = WebSocketClientSpy()
    let sut = MessagingService(
      url: url,
      authToken: authToken,
      httpClient: httpClient,
      webSocketClient: webSocketClient
    )
    
    trackForMemoryLeaks(webSocketClient, file: file, line: line)
    trackForMemoryLeaks(httpClient, file: file, line: line)
    
    return (sut, httpClient, webSocketClient)
  }
  
  private func expect(
    _ sut: MessagingService,
    toCompleteWithError expectedError: MessagingService.LoadMessagesError,
    when action: () -> Void,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let channelID = "CHANNEL_ID"
    let exp = expectation(description: "Wait for messages loading")
    
    sut.loadMessages(by: channelID) { result in
      switch result {
      case .failure(let gotError):
        switch (expectedError, gotError) {
        case (.server, .server): break
        case (.invalidData, .invalidData): break
        case (.invalidResponse, .invalidResponse): break
        case (.unknown(let expectedUnderlyingError as NSError), .unknown(let gotUnderlyingError as NSError)):
          XCTAssertEqual(expectedUnderlyingError.code, gotUnderlyingError.code, file: file, line: line)
          XCTAssertEqual(expectedUnderlyingError.domain, gotUnderlyingError.domain, file: file, line: line)
        default:
          XCTFail("Expected \(expectedError), got \(gotError) instead", file: file, line: line)
        }
      default:
        XCTFail("Expected \(expectedError) error, got \(result) instead", file: file, line: line)
      }
      exp.fulfill()
    }
    
    action()
    wait(for: [exp], timeout: 1)
  }
  
  private func anyMessagePayload() -> MessagingService.MessagePayload {
    MessagingService.MessagePayload(
      body: "message body",
      userID: "007",
      channelID: "777",
      userName: "James",
      userAvatar: "user avatar",
      userAvatarColor: "user avatar color"
    )
  }
  
  private func anyMessageInfos() -> [MessagingService.MessageInfo] {
    [
      .init(
        id: "1",
        messageBody: "body 1",
        userId: "user 1",
        channelId: "channel 1",
        userName: "A",
        userAvatar: "avatar 1",
        userAvatarColor: "avatar color 1",
        timeStamp: "now 1"
      ),
      .init(
        id: "2",
        messageBody: "body 2",
        userId: "user 2",
        channelId: "channel 2",
        userName: "B",
        userAvatar: "avatar 2",
        userAvatarColor: "avatar color 2",
        timeStamp: "now 2"
      )
    ]
  }
  
  private func anyMessageData(
  ) -> (
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
      "MESSAGE_BODY",
      "USER_ID",
      "CHANNEL_ID",
      "USER_NAME",
      "USER_AVATAR",
      "USER_AVATAR_COLOR",
      "ID",
      "TIMESTAMP"
    )
  }
  
  func anyURL(with channelID: String? = nil) -> URL {
    if let channelID {
      URL(string: "http://any-url.com/\(channelID)")!
    } else {
      URL(string: "http://any-url.com")!
    }
  }
  
  func anyAuthToken() -> String {
    "any token"
  }

  private final class HTTPClientSpy: HTTPClientProtocol {
    private var messages = [(request: URLRequest, completion: (Result<(Data?, HTTPURLResponse?), Error>) -> Void)]()
    
    var performCallCount: Int {
      messages.count
    }
    
    var requestedURLs: [URL] {
      messages.compactMap { $0.request.url }
    }
    
    var httpMethods: [String] {
      messages.compactMap { $0.request.httpMethod }
    }
    
    var contentTypes: [String] {
      messages.compactMap { $0.request.value(forHTTPHeaderField: "Content-Type") }
    }
    
    var authTokens: [String] {
      messages.compactMap { $0.request.value(forHTTPHeaderField: "Authorization") }
    }
    
    func perform(
      request: URLRequest,
      completion: @escaping (Result<(Data?, HTTPURLResponse?), any Error>) -> Void
    ) {
      messages.append((request, completion))
    }
    
    
    func completeMessagesLoading(with statusCode: Int, at index: Int = 0) {
      let response = HTTPURLResponse(
        url: URL(string: "http://any-url.com")!,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil
      )
      messages[index].completion(.success((nil, response)))
    }
    
    func completeMessagesLoading(with data: Data?, at index: Int = 0) {
      let response = HTTPURLResponse(
        url: URL(string: "http://any-url.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )
      messages[index].completion(.success((data, response)))
    }
    
    func completeMessagesLoading(with error: NSError, at index: Int = 0) {
      messages[index].completion(.failure(error))
    }
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
    
    struct EmitUserStopTypingMessage {
      let event: String
      let item1: String
    }
    
    struct EmitUserStartTypingMessage {
      let event: String
      let item1: String
      let item2: String
    }
    
    private(set) var onMessages = [OnMessage]()
    private(set) var emitMessages = [EmitMessage]()
    private(set) var emitUserStopTypingMessages = [EmitUserStopTypingMessage]()
    private(set) var emitUserStartTypingMessages = [EmitUserStartTypingMessage]()
    private(set) var connectCallCount = 0
    var emitMessageCallCount: Int {
      emitMessages.count
    }
    var emitUserStopTypingCallCount: Int {
      emitUserStopTypingMessages.count
    }
    var emitUserStartTypingCallCount: Int {
      emitUserStartTypingMessages.count
    }
    
    func connect() {
      connectCallCount += 1
    }
    
    func on(_ event: String, completion: @escaping ([Any]) -> Void) {
      onMessages.append(OnMessage(event: event, completion: completion))
    }
    
    func emit(_ event: String, _ item1: String) {
      emitUserStopTypingMessages.append(
        EmitUserStopTypingMessage(
          event: event,
          item1: item1
        )
      )
    }
    
    func emit(_ event: String, _ item1: String, _ item2: String) {
      emitUserStartTypingMessages.append(
        EmitUserStartTypingMessage(
          event: event,
          item1: item1,
          item2: item2
        )
      )
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
