//
//  MessagingServiceTests.swift
//  BeChattedMessagingTests
//
//  Created by Volodymyr Myroniuk on 22.08.2024.
//

import XCTest

protocol WebSocketClientProtocol {
  func connect()
  func on(_ event: String, completion: @escaping ([Any]) -> Void)
}

struct MessagingService {
  private let webSocketClient: WebSocketClientProtocol
  
  init(webSocketClient: WebSocketClientProtocol) {
    self.webSocketClient = webSocketClient
    
    webSocketClient.connect()
    webSocketClient.on("messageCreated") { _ in }
    webSocketClient.on("userTypingUpdate") { _ in }
  }
}

final class MessagingServiceTests: XCTestCase {
  func test_init_setsUpWebSocketClient() {
    let webSocketClient = WebSocketClientSpy()
    _ = MessagingService(webSocketClient: webSocketClient)
    
    XCTAssertEqual(webSocketClient.connectCallCount, 1)
    XCTAssertTrue(webSocketClient.onMessages.map { $0.event }.contains("messageCreated"))
    XCTAssertTrue(webSocketClient.onMessages.map { $0.event }.contains("userTypingUpdate"))
  }
  
  // MARK: - Helpers
  
  private final class WebSocketClientSpy: WebSocketClientProtocol {
    struct OnMessage {
      let event: String
      let completion: ([Any]) -> Void
    }
    
    private(set) var onMessages = [OnMessage]()
    private(set) var connectCallCount = 0
    
    func connect() {
      connectCallCount += 1
    }
    
    func on(_ event: String, completion: @escaping ([Any]) -> Void) {
      onMessages.append(OnMessage(event: event, completion: completion))
    }
  }
}
