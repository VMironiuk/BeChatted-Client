//
//  ChannelsView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI

struct ChannelsView: View {
    var body: some View {
        VStack {
        }
        .navigationTitle("Channels")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(Color.blue)
                    .frame(width: 44, height: 44)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChannelsView()
    }
}
