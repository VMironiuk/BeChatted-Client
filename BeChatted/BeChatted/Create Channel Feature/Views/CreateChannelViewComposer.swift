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
    
    public static func composedCreateChannelView(
        with viewModel: CreateChannelViewModel,
        onCreateChannelButtonTapped: @escaping () -> Void
    ) -> some View {
        CreateChannelView(viewModel: viewModel, onCreateChannelButtonTapped: onCreateChannelButtonTapped)
    }
}
