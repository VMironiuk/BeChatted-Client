//
//  CreateChannelFeatureComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 25.05.2024.
//

import SwiftUI

import BeChatted
import BeChattediOS

struct CreateChannelFeatureComposer {
    let appData: AppData
    let onSuccess: () -> Void
    
    var createChannelView: some View {
        CreateChannelViewComposer.composedCreateChannelView(
            with: CreateChannelViewModel(
                service: CreateChanelServiceComposer.createChannelService(
                    with: appData.authToken ?? ""
                ),
                onSuccess: onSuccess
            ),
            onCreateChannelButtonTapped: { UIApplication.shared.hideKeyboard() }
        )
    }
}
