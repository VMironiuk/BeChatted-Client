//
//  ChannelsViewComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI

public struct ChannelsViewComposer {
    private init() {}
    
    public static func composedChannelsView(with viewModel: ChannelsViewModel) -> some View {
        ChannelsView(viewModel: viewModel)
    }
}
