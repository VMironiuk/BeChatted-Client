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

public protocol MessagingServiceProtocol {
  func loadMessages(
    by channelID: String,
    completion: @escaping (Result<[MessageInfo], MessagingServiceError>) -> Void
  )
}

public final class ChannelViewModel: ObservableObject {
  public let channelItem: ChannelItem
  public let messagingService: MessagingServiceProtocol
  
  public init(channelItem: ChannelItem, messagingService: MessagingServiceProtocol) {
    self.channelItem = channelItem
    self.messagingService = messagingService
  }
  
  public func loadMessages(by channelID: String) {
    messagingService.loadMessages(by: channelID) { _ in
    }
  }
}
