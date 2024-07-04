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
          appData.authToken = nil
          appData.isUserLoggedIn = false
        }
      )
    )
  }
}

#Preview {
  ChannelsView(appData: AppData())
}
