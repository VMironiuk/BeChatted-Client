//
//  ChannelViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.09.2024.
//

import Foundation

public enum MessagingServiceError: Error {
  case server
  case invalidData
  case invalidResponse
  case unknown(Error)
}

public struct MessageInfo {
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

public protocol MessagingServiceProtocol {
  func loadMessages(
    by channelID: String,
    completion: @escaping (Result<[MessageInfo], MessagingServiceError>) -> Void
  )
  func sendMessage(_ message: MessagePayload)
}

public final class ChannelViewModel: ObservableObject {
  public let channelItem: ChannelItem
  public let messagingService: MessagingServiceProtocol
  
  @Published public private(set) var status: Result<[MessageInfo], MessagingServiceError> = .success([])
  
  public init(channelItem: ChannelItem, messagingService: MessagingServiceProtocol) {
    self.channelItem = channelItem
    self.messagingService = messagingService
  }
  
  public func loadMessages(by channelID: String) {
    messagingService.loadMessages(by: channelID) { [weak self] result in
      switch result {
      case .success(let messages): 
        self?.status = .success(messages)
      case .failure(let error):
        self?.status = .failure(error)
      }
    }
  }
  
  public func sendMessage(_ message: MessagePayload) {
    messagingService.sendMessage(message)
  }
}
