//
//  ChannelView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 13.07.2024.
//

import BeChatted
import SwiftUI

struct ChannelView: View {
  let channelItem: ChannelItem
  
  var body: some View {
    VStack {
      List {
        Group {
          Text("# \(channelItem.name)")
            .font(.system(size: 24, weight: .semibold))
          
          Text(channelItem.description)
            .font(.system(size: 16, weight: .regular))
            .opacity(0.6)
            .padding(.bottom, 32)
          
          ForEach(0..<10) { _ in
            MessageView()
          }
        }
        .listRowSeparator(.hidden)
      }
      .listStyle(.plain)
    }
    .toolbarRole(.editor)
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("# \(channelItem.name)")
  }
}

#Preview {
  NavigationStack {
    ChannelView(
      channelItem: ChannelItem(
        id: "id",
        name: "channel-name",
        description: "Channel description"
      )
    )
  }
}
