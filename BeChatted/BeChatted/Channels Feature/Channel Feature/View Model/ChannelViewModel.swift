//
//  ChannelViewModel.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.09.2024.
//

import Foundation

public final class ChannelViewModel: ObservableObject {
  public let channelItem: ChannelItem
  
  public init(channelItem: ChannelItem) {
    self.channelItem = channelItem
  }
}
