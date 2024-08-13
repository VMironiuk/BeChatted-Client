//
//  CreateChannelServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 08.08.2024.
//

import Foundation

public protocol CreateChannelServiceProtocol {
  func addChannel(withName name: String, description: String)
}
