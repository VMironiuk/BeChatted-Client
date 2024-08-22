//
//  MessagingServiceTests.swift
//  BeChattedMessagingTests
//
//  Created by Volodymyr Myroniuk on 22.08.2024.
//

import XCTest

protocol WebSocketClientProtocol {
  func connect()
}

struct MessagingService {
  private let webSocketClient: WebSocketClientProtocol
  
  init(webSocketClient: WebSocketClientProtocol) {
    self.webSocketClient = webSocketClient
    
    webSocketClient.connect()
  }
}

final class MessagingServiceTests: XCTestCase {
  func test_init_setsUpWebSocketClient() {
    let webSocketClient = WebSocketClientSpy()
    _ = MessagingService(webSocketClient: webSocketClient)
    
    XCTAssertEqual(webSocketClient.connectCallCount, 1)
  }
  
  // MARK: - Helpers
  
  private final class WebSocketClientSpy: WebSocketClientProtocol {
    private(set) var connectCallCount = 0
    
    func connect() {
      connectCallCount += 1
    }
  }
}
