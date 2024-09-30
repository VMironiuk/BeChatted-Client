//
//  ChannelViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.09.2024.
//

import Combine
import Foundation

public enum MessagingServiceError: Error {
  case server
  case invalidData
  case invalidResponse
  case unknown(Error)
}

public struct MessageInfo: Identifiable {
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
  
  init(
    from messageData: (
      body: String,
      userID: String,
      channelID: String,
      userName: String,
      userAvatar: String,
      userAvatarColor: String,
      id: String,
      timeStamp: String
    )
  ) {
    self.init(
      id: messageData.id,
      messageBody: messageData.body,
      userId: messageData.userID,
      channelId: messageData.channelID,
      userName: messageData.userName,
      userAvatar: messageData.userAvatar,
      userAvatarColor: messageData.userAvatarColor,
      timeStamp: messageData.timeStamp
    )
  }
}

public struct MessagePayload {
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

public struct User {
  public let id: String
  public let name: String
  
  public init(id: String, name: String) {
    self.id = id
    self.name = name
  }
}

public protocol MessagingServiceProtocol {
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

  var newMessage: PassthroughSubject<MessageData, Never> { get }
  func loadMessages(
    by channelID: String,
    completion: @escaping (Result<[MessageInfo], MessagingServiceError>) -> Void
  )
  func sendMessage(_ message: MessagePayload)
}

public final class ChannelViewModel: ObservableObject {
  private var newMessageSubscription: AnyCancellable?
  public let currentUser: User
  public let channelItem: ChannelItem
  public let messagingService: MessagingServiceProtocol
  
  @Published public private(set) var status: Result<[MessageInfo], MessagingServiceError> = .success([])
  
  public init(currentUser: User, channelItem: ChannelItem, messagingService: MessagingServiceProtocol) {
    self.currentUser = currentUser
    self.channelItem = channelItem
    self.messagingService = messagingService
    
    newMessageSubscription = messagingService.newMessage.sink { [weak self] value in
      guard var messages = try? self?.status.get() else { return }
      messages.append(MessageInfo(from: value))
      self?.status = .success(messages)
    }
  }
  
  public func loadMessages() {
    messagingService.loadMessages(by: channelItem.id) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let messages): 
          self?.status = .success(messages)
        case .failure(let error):
          self?.status = .failure(error)
        }
      }
    }
  }
  
  public func sendMessage(_ message: MessagePayload) {
    messagingService.sendMessage(message)
  }
}
