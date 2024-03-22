//
//  ChannelsView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI

struct ChannelsView: View {
    let channelItems: [ChannelItem]
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(channelItems) { channelItem in
                        ChannelItemView(channelItem: channelItem)
                    }
                } header: {
                    ZStack {
                        Rectangle()
                            .frame(height: 82)
                            .foregroundStyle(Color.white)
                        VStack {
                            Button("Create Channel") {
                            }
                            .buttonStyle(CreateChanelButtonStyle())
                            .padding(16)
                            Divider()
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
        .navigationTitle("Channels")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    ImageProvider.avatarPrototype
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

struct ChannelItem: Identifiable {
    let id = UUID()
    let name: String?
    var isListTitle: Bool {
        name == nil
    }
}

struct ChannelItemView: View {
    let channelItem: ChannelItem
    
    var body: some View {
        if channelItem.isListTitle {
            HStack {
                Text("Recommended channels")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(ColorProvider.recommendedChannelsLabelColor)
                    .padding(.horizontal, 16)
                    .padding(.top, 64)
                    .padding(.bottom, 24)
                Spacer()
            }
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.teal)
                    .frame(height: 52)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChannelsView(
            channelItems: [
                ChannelItem(name: nil),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: ""),
                ChannelItem(name: "")])
    }
}
