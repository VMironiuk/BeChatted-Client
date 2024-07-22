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
  
  @State private var messageText = ""
  
  var body: some View {
    VStack {
      contentView
      bottomView
    }
    .toolbarRole(.editor)
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("# \(channelItem.name)")
  }
}

extension ChannelView {
  private var contentView: some View {
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
  
  private var bottomView: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .bottom) {
        TextField("Message", text: $messageText, axis: .vertical)
          .textFieldStyle(.roundedBorder)
          .lineLimit(10)
        
        Spacer(minLength: 16)
        
        Button {
        } label: {
          Image(systemName: "paperplane.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
        }
      }
      
      Text("Username is typing ...")
        .font(.caption)
        .opacity(0.6)
        .padding(.horizontal, 8)
        .hidden()
    }
    .padding()
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
