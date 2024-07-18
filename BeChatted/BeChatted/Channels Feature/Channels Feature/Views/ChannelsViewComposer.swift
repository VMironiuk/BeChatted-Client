//
//  ChannelsViewComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI
import BeChatted

public struct ChannelsViewComposer {
  private init() {}
  
  public static func composedChannelsView<CreateChannelContent: View, UserProfileContent: View>(
    with viewModel: ChannelsViewModel,
    createChannelContent: CreateChannelContent,
    userProfileContent: UserProfileContent,
    onChannelTap: @escaping (ChannelItem) -> Void
  ) -> some View {
    ChannelsView(
      viewModel: viewModel,
      createChannelContent: createChannelContent,
      userProfileContent: userProfileContent,
      onChannelTap: onChannelTap
    )
  }
}
