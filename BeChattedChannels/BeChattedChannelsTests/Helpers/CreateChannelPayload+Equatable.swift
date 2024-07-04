//
//  CreateChannelPayload+Equatable.swift
//  BeChattedChannelsTests
//
//  Created by Volodymyr Myroniuk on 16.05.2024.
//

import BeChattedChannels

extension CreateChanelPayload: Equatable {
  public static func == (lhs: CreateChanelPayload, rhs: CreateChanelPayload) -> Bool {
    lhs.name == rhs.name && lhs.description == rhs.description
  }
}
