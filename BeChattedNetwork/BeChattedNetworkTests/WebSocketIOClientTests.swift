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
    
    override func connect(withPayload payload: [String : Any]? = nil) {
      connectCallCount += 1
    }
    
    override func disconnect() {
      disconnectCallCount += 1
    }
  }
}
