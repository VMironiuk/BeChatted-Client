//
//  AddNewUserServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.03.2023.
//

import Foundation

public struct NewUserPayload: Codable, Equatable {
  private enum CodingKeys: String, CodingKey {
    case name
    case email
    case avatarName
    case avatarColor
  }

  private let name: String
  private let email: String
  private let avatarName: String
  private let avatarColor: String
  
  public init(name: String, email: String, avatarName: String, avatarColor: String) {
    self.name = name
    self.email = email
    self.avatarName = avatarName
    self.avatarColor = avatarColor
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let name = try container.decode(String.self, forKey: .name)
    let email = try container.decode(String.self, forKey: .email)
    let avatarName = try container.decode(String.self, forKey: .avatarName)
    let avatarColor = try container.decode(String.self, forKey: .avatarColor)
    
    self.init(name: name, email: email, avatarName: avatarName, avatarColor: avatarColor)
  }
}

public struct NewUserInfo: Decodable, Equatable {
  public let name: String
  public let email: String
  public let avatarName: String
  public let avatarColor: String
}

enum AddNewUserServiceError: Error {
  case connectivity
  case server
  case unknown
  case invalidData
}

protocol AddNewUserServiceProtocol {
  func send(
    newUserPayload: NewUserPayload,
    authToken: String,
    completion: @escaping (Result<NewUserInfo, AddNewUserServiceError>) -> Void
  )
}
