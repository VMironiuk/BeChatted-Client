//
//  ChannelViewComposer.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 17.07.2024.
//

import BeChatted
import SwiftUI

public enum ChannelViewComposer {
  public static func composedChannelView(
    with currentUser: User,
    channelItem: ChannelItem,
    messagingService: MessagingServiceProtocol
  ) -> some View {
    ChannelView(
      viewModel: ChannelViewModel(
        currentUser: currentUser,
        channelItem: channelItem,
        messagingService: messagingService
      )
    )
  }
}
