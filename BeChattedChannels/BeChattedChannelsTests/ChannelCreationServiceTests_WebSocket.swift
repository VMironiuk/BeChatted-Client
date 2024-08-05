//
//  ChannelCreationServiceTests_WebSocket.swift
//  BeChattedChannelsTests
//
//  Created by Volodymyr Myroniuk on 03.08.2024.
//

import XCTest
import BeChattedChannels

struct ChannelCreationService_WebSocket {
  private let webSocketClient: WebSocketClientProtocol
  
  init(webSocketClient: WebSocketClientProtocol) {
    self.webSocketClient = webSocketClient
    
    webSocketClient.connect()
  }
}

final class ChannelCreationServiceTests_WebSocket: XCTestCase {
  func test_init_sendsConnectMessage() {
    // given
    
    // when
    let url = URL(string: "http://any-url.com")!
    let socket = WebSocketClientSpy(url: url)
    _ = ChannelCreationService_WebSocket(webSocketClient: socket)
    
    // then
    XCTAssertEqual(socket.connectCallCount, 1)
    XCTAssertEqual(socket.disconnectCallCount, 0)
    XCTAssertEqual(socket.emitCallCount, 0)
    XCTAssertEqual(socket.onCallCount, 0)
  }
  
  // MARK: - Helpers
  
  private final class WebSocketClientSpy: WebSocketClientProtocol {
    private(set) var connectCallCount = 0
    private(set) var disconnectCallCount = 0
    private(set) var emitCallCount = 0
    private(set) var onCallCount = 0
    
    init(url: URL) {
    }
    
    func connect() {
      connectCallCount += 1
    }
    
    func disconnect() {
      disconnectCallCount += 1
    }
    
    func emit(_ event: String, _ items: Any...) {
      emitCallCount += 1
    }
    
    func on(_ event: String, completion: @escaping ([Any]) -> Void) {
      onCallCount += 1
    }
  }
}
