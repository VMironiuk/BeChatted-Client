//
//  MessagingService.swift
//  BeChattedMessaging
//
//  Created by Volodymyr Myroniuk on 03.09.2024.
//

import Combine

public protocol HTTPClientProtocol {
  func perform(
    request: URLRequest,
    completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void)
}

public protocol WebSocketClientProtocol {
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

public struct MessagingService {
  private let url: URL
  private let httpClient: HTTPClientProtocol
  private let webSocketClient: WebSocketClientProtocol
  
  public let newMessage = PassthroughSubject<MessageData, Never>()
  
  public init(
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
  
  public func sendMessage(_ message: MessagePayload) {
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
  
  public func loadMessages(
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

public extension MessagingService {
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
  
  enum LoadMessagesError: Error {
    case server
    case invalidData
    case invalidResponse
    case unknown(Error)
  }

  enum Event: String {
    case messageCreated
    case userTypingUpdate
    case newMessage
  }

  struct MessagePayload {
    public let body: String
    public let userID: String
    public let channelID: String
    public let userName: String
    public let userAvatar: String
    public let userAvatarColor: String
    
    public init(
      body: String,
      userID: String,
      channelID: String,
      userName: String,
      userAvatar: String,
      userAvatarColor: String
    ) {
      self.body = body
      self.userID = userID
      self.channelID = channelID
      self.userName = userName
      self.userAvatar = userAvatar
      self.userAvatarColor = userAvatarColor
    }
  }
  
  struct MessageInfo: Codable {
    public let id: String
    public let messageBody: String
    public let userId: String
    public let channelId: String
    public let userName: String
    public let userAvatar: String
    public let userAvatarColor: String
    public let timeStamp: String
    
    public init(
      id: String,
      messageBody: String,
      userId: String,
      channelId: String,
      userName: String,
      userAvatar: String, 
      userAvatarColor: String,
      timeStamp: String
    ) {
      self.id = id
      self.messageBody = messageBody
      self.userId = userId
      self.channelId = channelId
      self.userName = userName
      self.userAvatar = userAvatar
      self.userAvatarColor = userAvatarColor
      self.timeStamp = timeStamp
    }
    
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
}
