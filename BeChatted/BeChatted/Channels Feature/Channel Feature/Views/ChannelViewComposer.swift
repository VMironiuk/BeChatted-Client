//
//  ChannelViewComposer.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 17.07.2024.
//

import BeChatted
import SwiftUI

public enum ChannelViewComposer {
  public static func composedChannelView(with channelItem: ChannelItem) -> some View {
    ChannelView(channelItem: channelItem)
  }
}