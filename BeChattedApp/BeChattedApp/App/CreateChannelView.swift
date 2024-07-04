//
//  CreateChannelView.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 15.06.2024.
//

import SwiftUI
import BeChatted
import BeChattediOS

struct CreateChannelView: View {
  @ObservedObject private var appData: AppData
  private let onSuccess: () -> Void
  
  @StateObject private var createChannelViewModel: CreateChannelViewModel
  
  init(appData: AppData, onSuccess: @escaping () -> Void) {
    self.appData = appData
    self.onSuccess = onSuccess
    
    _createChannelViewModel = StateObject(
      wrappedValue: CreateChannelViewModel(
        service: CreateChanelServiceComposer.createChannelService(with: appData.authToken ?? ""),
        onSuccess: onSuccess
      )
    )
  }
  
  var body: some View {
    CreateChannelViewComposer.composedCreateChannelView(
      with: createChannelViewModel,
      onCreateChannelButtonTapped: { UIApplication.shared.hideKeyboard() }
    )
  }
}

#Preview {
  CreateChannelView(appData: AppData(), onSuccess: {})
}
