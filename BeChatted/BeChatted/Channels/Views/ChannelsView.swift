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
                    ForEach(channelItems) { channelItemView(for: $0) }
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
    
    @ViewBuilder
    private func channelItemView(for channelItem: ChannelItem) -> some View {
        switch channelItem {
        case .title:
            ChannelTitleView()
        case let .channel(channelName, isUnread):
            ChannelItemView(channelName: channelName, isUnread: isUnread)
        }
    }
}

enum ChannelItem: Identifiable {
    var id: UUID { UUID() }
    case title
    case channel(name: String, isUnread: Bool)
}

struct ChannelTitleView: View {
    var body: some View {
        HStack {
            Text("Recommended channels")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(ColorProvider.recommendedChannelsLabelColor)
                .padding(.horizontal, 16)
                .padding(.top, 64)
                .padding(.bottom, 24)
            Spacer()
        }
    }
}

struct ChannelItemView: View {
    let channelName: String
    let isUnread: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(ColorProvider.channelItemBackgroundColor)
                .frame(height: 52)
                .padding(.horizontal, 16)
                .padding(.top, 8)
            HStack {
                Text("#")
                    .font(.system(size: 20, weight: isUnread ? .black : .regular))
                    .padding(.leading, 32)
                    .padding(.trailing, 16)
                Text(channelName)
                    .font(.system(size: 16, weight: isUnread ? .black : .regular))
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChannelsView(
            channelItems: [
                .title,
                .channel(name: "general", isUnread: false),
                .channel(name: "announcements", isUnread: true),
                .channel(name: "main", isUnread: false),
                .channel(name: "random", isUnread: true),
                .channel(name: "onboarding", isUnread: false),
                .channel(name: "off-topic", isUnread: false),
                .channel(name: "books", isUnread: false)])
    }
}
