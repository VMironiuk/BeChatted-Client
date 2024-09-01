//
//  MessagingServiceTests.swift
//  BeChattedMessagingTests
//
//  Created by Volodymyr Myroniuk on 22.08.2024.
//

import XCTest

import Combine

protocol HTTPClientProtocol {
  func perform(
    request: URLRequest,
    completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void)
}

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
  
  struct MessagePayload {
    let body: String
    let userID: String
    let channelID: String
    let userName: String
    let userAvatar: String
    let userAvatarColor: String
  }
  
  struct MessageInfo: Codable {
    let id: String
    let messageBody: String
    let userId: String
    let channelId: String
    let userName: String
    let userAvatar: String
    let userAvatarColor: String
    let timeStamp: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case messageBody
        case userId
        case channelId
        case userName
        case userAvatar
        case userAvatarColor
        case timeStamp
    }
  }
  
  enum Event: String {
    case messageCreated
    case userTypingUpdate
    case newMessage
  }
  
  enum LoadMessagesError: Error {
    case server
    case invalidData
    case invalidResponse
    case unknown(Error)
  }
  
  private let url: URL
  private let httpClient: HTTPClientProtocol
  private let webSocketClient: WebSocketClientProtocol
  
  let newMessage = PassthroughSubject<MessageData, Never>()
  
  init(
    url: URL,
    httpClient: HTTPClientProtocol,
    webSocketClient: WebSocketClientProtocol
  ) {
    self.url = url
    self.httpClient = httpClient
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
  }
  
  func sendMessage(_ message: MessagePayload) {
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
  
  func loadMessages(
    by channelID: String,
    completion: @escaping (Result<[MessageInfo], LoadMessagesError>) -> Void
  ) {
    let request = URLRequest(url: url)
    
    httpClient.perform(request: request) { result in
      switch result {
      case let .success((data, response)):
        guard response?.statusCode != 500 else {
          completion(.failure(.server))
          return
        }
        
        if response?.statusCode == 200 {
          if let data, let messages = try? JSONDecoder().decode([MessageInfo].self, from: data) {
            completion(.success(messages))
          } else {
            completion(.failure(.invalidData))
          }
        } else {
          completion(.failure(.invalidResponse))
        }
      case .failure(let error):
        completion(.failure(.unknown(error)))
      }
    }
  }
}

final class MessagingServiceTests: XCTestCase {
  func test_init_setsUpWebSocketClient() {
    let (_, _, webSocketClient) = makeSUT()
    
    XCTAssertEqual(webSocketClient.connectCallCount, 1)
    XCTAssertTrue(webSocketClient.onMessages.map { $0.event }.contains(MessagingService.Event.messageCreated.rawValue))
  }
  
  func test_sendMessage_emitsNewMessage() {
    let message = MessagingService.MessagePayload(
      body: "message body",
      userID: "007",
      channelID: "777",
      userName: "James",
      userAvatar: "user avatar",
      userAvatarColor: "user avatar color"
    )
    let (sut, _,webSocketClient) = makeSUT()

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
    let (sut, _, webSocketClient) = makeSUT()
    
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
  
  func test_loadMessages_callsHTTPClientPerform() {
    let channelID = "CHANNEL_ID"
    let (sut, httpClient, _) = makeSUT()
    
    sut.loadMessages(by: channelID) { _ in }
    
    XCTAssertEqual(httpClient.performCallCount, 1)
  }
  
  func test_loadMessages_deliversServerErrorOn500HTTPResponse() {
    let channelID = "CHANNEL_ID"
    let exp = expectation(description: "Wait for messages loading")
    let (sut, httpClient, _) = makeSUT()
    
    sut.loadMessages(by: channelID) { result in
      switch result {
      case .failure(let error):
        XCTAssertEqual(error, MessagingService.LoadMessagesError.server)
      default:
        XCTFail("Expected server error, got \(result) instead")
      }
      exp.fulfill()
    }
    
    httpClient.completeMessagesLoading(with: 500)
    wait(for: [exp], timeout: 1)
  }
  
  func test_loadMessages_deliversInvalidDataErrorOn200HTTPResponseButInvalidData() {
    let channelID = "CHANNEL_ID"
    let exp = expectation(description: "Wait for messages loading")
    let (sut, httpClient, _) = makeSUT()
    
    sut.loadMessages(by: channelID) { result in
      switch result {
      case .failure(let error):
        XCTAssertEqual(error, MessagingService.LoadMessagesError.invalidData)
      default:
        XCTFail("Expected server error, got \(result) instead")
      }
      exp.fulfill()
    }
    
    httpClient.completeMessagesLoading(with: "invalid data".data(using: .utf8))
    wait(for: [exp], timeout: 1)
  }
  
  func test_loadMessages_deliversInvalidResponseErrorOnNon200And500HTTPResponse() {
    let channelID = "CHANNEL_ID"
    let exp = expectation(description: "Wait for messages loading")
    let (sut, httpClient, _) = makeSUT()
    
    sut.loadMessages(by: channelID) { result in
      switch result {
      case .failure(let error):
        XCTAssertEqual(error, MessagingService.LoadMessagesError.invalidResponse)
      default:
        XCTFail("Expected server error, got \(result) instead")
      }
      exp.fulfill()
    }
    
    httpClient.completeMessagesLoading(with: 404)
    wait(for: [exp], timeout: 1)
  }
  
  func test_loadMessages_deliversUnknownErrorOnFailedRequestPerforming() {
    let channelID = "CHANNEL_ID"
    let underlyingError = NSError(domain: "some domain", code: 42)
    let exp = expectation(description: "Wait for messages loading")
    let (sut, httpClient, _) = makeSUT()
    
    sut.loadMessages(by: channelID) { result in
      switch result {
      case .failure(let error):
        if case let .unknown(gotError) = error {
          XCTAssertEqual((gotError as NSError).code, underlyingError.code)
          XCTAssertEqual((gotError as NSError).domain, underlyingError.domain)
        } else {
          XCTFail("Expected wrong error type")
        }
      default:
        XCTFail("Expected server error, got \(result) instead")
      }
      exp.fulfill()
    }
    
    httpClient.completeMessagesLoading(with: underlyingError)
    wait(for: [exp], timeout: 1)
  }
  
  func test_loadMessages_deliversMessages() {
    let channelID = "CHANNEL_ID"
    let expectedMessages: [MessagingService.MessageInfo] = [
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
  
  // MARK: - Helpers
  
  private func makeSUT(
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (MessagingService, HTTPClientSpy, WebSocketClientSpy) {
    let url = URL(string: "http://any-url.com")!
    let httpClient = HTTPClientSpy()
    let webSocketClient = WebSocketClientSpy()
    let sut = MessagingService(url: url, httpClient: httpClient, webSocketClient: webSocketClient)
    
    trackForMemoryLeaks(webSocketClient, file: file, line: line)
    trackForMemoryLeaks(httpClient, file: file, line: line)
    
    return (sut, httpClient, webSocketClient)
  }
  
  private final class HTTPClientSpy: HTTPClientProtocol {
    private var completions = [(Result<(Data?, HTTPURLResponse?), Error>) -> Void]()
    
    var performCallCount: Int {
      completions.count
    }
    
    func perform(
      request: URLRequest,
      completion: @escaping (Result<(Data?, HTTPURLResponse?), any Error>) -> Void
    ) {
      completions.append(completion)
    }
    
    
    func completeMessagesLoading(with statusCode: Int, at index: Int = 0) {
      let response = HTTPURLResponse(
        url: URL(string: "http://any-url.com")!,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil
      )
      completions[index](.success((nil, response)))
    }
    
    func completeMessagesLoading(with data: Data?, at index: Int = 0) {
      let response = HTTPURLResponse(
        url: URL(string: "http://any-url.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )
      completions[index](.success((data, response)))
    }
    
    func completeMessagesLoading(with error: NSError, at index: Int = 0) {
      completions[index](.failure(error))
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

extension MessagingService.LoadMessagesError: Equatable {
  static func == (
    lhs: MessagingService.LoadMessagesError,
    rhs: MessagingService.LoadMessagesError
  ) -> Bool {
    switch (lhs, rhs) {
    case (.server, .server): true
    case (.invalidData, .invalidData): true
    case (.invalidResponse, .invalidResponse): true
    case (.unknown, .unknown): true
    default: false
    }
  }
}

extension MessagingService.MessageInfo: Equatable {}
