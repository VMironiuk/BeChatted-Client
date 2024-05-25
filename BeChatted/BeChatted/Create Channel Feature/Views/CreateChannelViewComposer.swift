//
//  CreateChannelViewComposer.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 25.05.2024.
//

import SwiftUI
import BeChatted

public struct CreateChannelViewComposer {
    private init() {}
    
    public static func composedCreateChannelView(with viewModel: CreateChannelViewModel) -> some View {
        CreateChannelView(viewModel: viewModel)
    }
}
