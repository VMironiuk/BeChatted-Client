//
//  ChannelsView.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 15.06.2024.
//

import AVFoundation
import SwiftUI
import BeChatted
import BeChattediOS

struct ChannelsView: View {
  @EnvironmentObject private var mainNavigationController: MainNavigationController
  @ObservedObject private var appData: AppData
  @StateObject private var channelsViewModel: ChannelsViewModel
  
  init(appData: AppData) {
    self.appData = appData
    
    _channelsViewModel = StateObject(
      wrappedValue: ChannelsViewModel(
        channelsLoadingService: ChannelsLoadingServiceComposer.channelsService(
          with: appData.authToken ?? ""
        )
      )
    )
  }
  
  var body: some View {
    ChannelsViewComposer.composedChannelsView(
      with: channelsViewModel,
      createChannelContent: CreateChannelView(
        appData: appData, 
        onSuccess: {
          AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
          channelsViewModel.loadChannels()
        }
      ),
      userProfileContent: UserProfileView(
        appData: appData,
        onLogoutAction: {
          appData.currentUser = nil
          appData.authToken = nil
        }
      ),
      onChannelTap: { channelItem in
        mainNavigationController.goToChannel(channelItem)
      }
    )
    .navigationDestination(
      for: MainNavigationController.Destination.self) { destination in
        if case let .channel(channelItem) = destination {
          ChannelViewComposer.composedChannelView(
            with: BeChatted.User(
              id: appData.currentUser!.id,
              name: appData.currentUser!.name
            ),
            channelItem: channelItem,
            messagingService: MessagingServiceComposer
              .messagingService(with: appData.authToken ?? "")
          )
        }
    }
  }
}

#Preview {
  ChannelsView(appData: AppData())
}
