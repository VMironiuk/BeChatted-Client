//
//  WebSocketIOClientTests.swift
//  BeChattedNetworkTests
//
//  Created by Volodymyr Myroniuk on 31.07.2024.
//

import XCTest
import BeChattedNetwork
import SocketIO

final class WebSocketIOClientTests: XCTestCase {
  
  func test_connect_callsSocketIOClient_connect() {
    let socketManager = SocketManagerStub(socketURL: URL(string: "http://any-url.com")!)
    let sut = WebSocketIOClient(socketManager: socketManager)
    
    sut.connect()
    
    XCTAssertEqual((socketManager.defaultSocket as? SocketIOClientSpy)?.connectCallCount, 1)
  }
  
  func test_disconnect_callsSocketIOClient_disconnect() {
    let socketManager = SocketManagerStub(socketURL: URL(string: "http://any-url.com")!)
    let sut = WebSocketIOClient(socketManager: socketManager)
    
    sut.disconnect()
    
    XCTAssertEqual((socketManager.defaultSocket as? SocketIOClientSpy)?.disconnectCallCount, 1)
  }
  
  func test_emit_sendsEmitMessage() {
    let expectedEvent = "addUserEvent"
    let expectedUsernameItem = "username item"
    let expectedPasswordItem = "password item"
    let socketManager = SocketManagerStub(socketURL: URL(string: "http://any-url.com")!)
    let sut = WebSocketIOClient(socketManager: socketManager)
    
    sut.emit(expectedEvent, expectedUsernameItem, expectedPasswordItem)
    
    let emitMessage = (socketManager.defaultSocket as! SocketIOClientSpy).emitMessages[0]
    XCTAssertEqual(emitMessage.event, expectedEvent)
    XCTAssertEqual(emitMessage.items[0] as! [String], [expectedUsernameItem, expectedPasswordItem])
  }
  
  func test_on_sendsOnMessage() {
    let event = "onNewMessage"
    let expectedItems = ["Charlie", "How are you?"]
    let exp = expectation(description: "Wait for new event")
    let socketManager = SocketManagerStub(socketURL: URL(string: "http://any-url.com")!)
    let sut = WebSocketIOClient(socketManager: socketManager)

    sut.on(event) { items in
      XCTAssertEqual(expectedItems, items as! [String])
      exp.fulfill()
    }
    (socketManager.defaultSocket as? SocketIOClientSpy)?.completeOnMessage(with: event, items: expectedItems)
    
    wait(for: [exp], timeout: 1)
  }
  
  // MARK: - Helpers
  
  private final class SocketManagerStub: SocketManager {
    override func socket(forNamespace nsp: String) -> SocketIOClient {
      if let socket = nsps[nsp] { return socket }
      let client = SocketIOClientSpy(manager: self, nsp: nsp)
      nsps[nsp] = client
      return client
    }
  }
  
  private final class SocketIOClientSpy: SocketIOClient {
    private(set) var connectCallCount = 0
    private(set) var disconnectCallCount = 0
    private(set) var emitMessages = [(event: String, items: [SocketData])]()
    private var onMessages = [String: NormalCallback]()
    
    override func connect(withPayload payload: [String : Any]? = nil) {
      connectCallCount += 1
    }
    
    override func disconnect() {
      disconnectCallCount += 1
    }
    
    override func emit(_ event: String, _ items: any SocketData..., completion: (() -> ())? = nil) {
      emitMessages.append((event, items))
    }
    
    @discardableResult
    override func on(_ event: String, callback: @escaping NormalCallback) -> UUID {
      onMessages[event] = callback
      return UUID()
    }
    
    func completeOnMessage(with event: String, items: [Any]) {
      onMessages[event]?(items, SocketAckEmitter(socket: self, ackNum: 1))
    }
  }
}
