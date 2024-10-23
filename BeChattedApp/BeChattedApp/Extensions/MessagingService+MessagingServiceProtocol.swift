//
//  MessagingService+MessagingServiceProtocol.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 06.09.2024.
//

import BeChatted
import BeChattedMessaging
import Combine

struct MessagingServiceWrapper: MessagingServiceProtocol {
  let underlyingService: MessagingService
  
  var newMessage: PassthroughSubject<MessageData, Never> {
    underlyingService.newMessage
  }
  
  var usersTypingUpdate: PassthroughSubject<[Any], Never> {
    underlyingService.usersTypingUpdate
  }
  
  func loadMessages(
    by channelID: String,
    completion: @escaping (Result<[BeChatted.MessageInfo], BeChatted.MessagingServiceError>) -> Void
  ) {
    underlyingService.loadMessages(by: channelID)
    { (result: Result<[MessagingService.MessageInfo], MessagingService.LoadMessagesError>) in
      switch result {
      case .success(let messages):
        completion(.success(messages.map { BeChatted.MessageInfo($0) }))
      case .failure(let error):
        completion(.failure(error.mapped))
      }
    }
  }
  
  func sendMessage(_ message: BeChatted.MessagePayload) {
    underlyingService.sendMessage(.init(message))
  }
  
  func sendUserStartTyping(_ userName: String, channelID: String) {
    underlyingService.sendUserStartTyping(userName, channelID: channelID)
  }
  
  func sendUserStopTyping(_ userName: String) {
    underlyingService.sendUserStopTyping(userName)
  }
}

private extension BeChatted.MessageInfo {
  init(_ messagingServiceMessageInfo: MessagingService.MessageInfo) {
    self.init(
      id: messagingServiceMessageInfo.id,
      messageBody: messagingServiceMessageInfo.messageBody,
      userId: messagingServiceMessageInfo.userId,
      channelId: messagingServiceMessageInfo.channelId,
      userName: messagingServiceMessageInfo.userName,
      userAvatar: messagingServiceMessageInfo.userAvatar,
      userAvatarColor: messagingServiceMessageInfo.userAvatarColor,
      timeStamp: messagingServiceMessageInfo.timeStamp
    )
  }
}

private extension MessagingService.MessagePayload {
  init(_ messagingServiceMessagePayload: BeChatted.MessagePayload) {
    self.init(
      body: messagingServiceMessagePayload.body,
      userID: messagingServiceMessagePayload.userID,
      channelID: messagingServiceMessagePayload.channelID,
      userName: messagingServiceMessagePayload.userName,
      userAvatar: messagingServiceMessagePayload.userAvatar,
      userAvatarColor: messagingServiceMessagePayload.userAvatarColor
    )
  }
}

private extension MessagingService.LoadMessagesError {
  var mapped: BeChatted.MessagingServiceError {
    switch self {
    case .server: .server
    case .invalidData: .invalidData
    case .invalidResponse: .invalidResponse
    case .unknown(let error): .unknown(error)
    @unknown default: fatalError()
    }
  }
}
