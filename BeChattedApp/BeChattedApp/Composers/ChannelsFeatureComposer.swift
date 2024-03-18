//
//  ChannelsFeatureComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import BeChattediOS
import SwiftUI

struct ChannelsFeatureComposer {
    let navigationController: MainNavigationController
    
    var channelsView: some View {
        ChannelsViewComposer.composedChannelsView()
    }
}
