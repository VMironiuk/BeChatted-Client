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
  func emit(_ event: String, _ item1: String)
  func emit(_ event: String, _ item1: String, _ item2: String)
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
  private let authToken: String
  private let httpClient: HTTPClientProtocol
  private let webSocketClient: WebSocketClientProtocol
  
  private var urlString: String {
    url.absoluteString
  }
  
  public let newMessage = PassthroughSubject<MessageData, Never>()
  public let usersTypingUpdate = PassthroughSubject<[Any], Never>()
  
  public init(
    url: URL,
    authToken: String,
    httpClient: HTTPClientProtocol,
    webSocketClient: WebSocketClientProtocol
  ) {
    self.url = url
    self.authToken = authToken
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
    webSocketClient.on(Event.userTypingUpdate.rawValue) { [weak usersTypingUpdate] value in
      usersTypingUpdate?.send(value)
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
    guard let url = URL(string: "\(urlString)/\(channelID)") else {
      completion(.failure(.invalidData))
      return
    }
    
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    
    httpClient.perform(request: request) { result in
      switch result {
      case let .success((data, response)):
        completion(MessagingServiceResultMapper.result(for: data, response: response))
      case .failure(let error):
        completion(.failure(.unknown(error)))
      }
    }
  }
  
  public func sendUserStartTyping(_ userName: String, channelID: String) {
    webSocketClient.emit(
      Event.startType.rawValue,
      userName,
      channelID
    )
  }
  
  public func sendUserStopTyping(_ userName: String) {
    webSocketClient.emit(
      Event.stopType.rawValue,
      userName
    )
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
    case startType
    case stopType
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

extension MessagingService.LoadMessagesError: Equatable {
  public static func == (
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

extension MessagingService.MessageInfo: Equatable {
  public static func == (
    lhs: MessagingService.MessageInfo,
    rhs: MessagingService.MessageInfo
  ) -> Bool {
    lhs.id == rhs.id
    || lhs.messageBody == rhs.messageBody
    || lhs.userId == rhs.userId
    || lhs.channelId == rhs.channelId
    || lhs.userName == rhs.userName
    || lhs.userAvatar == rhs.userAvatar
    || lhs.userAvatarColor == rhs.userAvatarColor
    || lhs.timeStamp == rhs.timeStamp
  }
}
