//
//  ChannelCreationServiceTests.swift
//  BeChattedChannelsTests
//
//  Created by Volodymyr Myroniuk on 03.08.2024.
//

import XCTest
import BeChattedChannels

final class ChannelCreationServiceTests: XCTestCase {
  func test_init_sendsConnectMessage() {
    // given
    
    // when
    let url = URL(string: "http://any-url.com")!
    let socket = WebSocketClientSpy(url: url)
    _ = ChannelCreationService(webSocketClient: socket)
    
    // then
    XCTAssertEqual(socket.connectCallCount, 1)
    XCTAssertEqual(socket.disconnectCallCount, 0)
    XCTAssertEqual(socket.emitCallCount, 0)
    XCTAssertEqual(socket.onCallCount, 0)
  }
  
  func test_addChannel_sendsEmitMessageWithNewChannelPayloadWithCorrectEvent() {
    // given
    let url = URL(string: "http://any-url.com")!
    let socket = WebSocketClientSpy(url: url)
    let sut = ChannelCreationService(webSocketClient: socket)
    let channel = CreateChanelPayload(name: "channel name", description: "channel description")
    
    // when
    sut.addChannel(channel)
    
    // then
    XCTAssertEqual(socket.connectCallCount, 1)
    XCTAssertEqual(socket.disconnectCallCount, 0)
    XCTAssertEqual(socket.emitCallCount, 1)
    XCTAssertEqual(socket.onCallCount, 0)
    
    XCTAssertEqual(socket.emitMessages[0].event, "newChannel")
    XCTAssertEqual(socket.emitMessages[0].items[0], channel.name)
    XCTAssertEqual(socket.emitMessages[0].items[1], channel.description)
  }
  
  // MARK: - Helpers
  
  private final class WebSocketClientSpy: WebSocketClientProtocol {
    struct EmitMessage {
      let event: String
      let items: [String]
    }
    
    private(set) var connectCallCount = 0
    private(set) var disconnectCallCount = 0
    var emitCallCount: Int { emitMessages.count }
    private(set) var onCallCount = 0
    private(set) var emitMessages = [EmitMessage]()
    
    init(url: URL) {
    }
    
    func connect() {
      connectCallCount += 1
    }
    
    func disconnect() {
      disconnectCallCount += 1
    }
    
    func emit(_ event: String, _ item1: String, _ item2: String) {
      emitMessages.append(EmitMessage(event: event, items: [item1, item2]))
    }
    
    func on(_ event: String, completion: @escaping ([Any]) -> Void) {
      onCallCount += 1
    }
  }
}
