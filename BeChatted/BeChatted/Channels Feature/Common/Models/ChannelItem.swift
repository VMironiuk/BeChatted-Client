//
//  ChannelItem.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 17.07.2024.
//

import Foundation

public struct ChannelItem: Equatable, Identifiable {
  public let id: String
  public let name: String
  public let description: String
  
  public init(id: String, name: String, description: String) {
    self.id = id
    self.name = name
    self.description = description
  }
}
