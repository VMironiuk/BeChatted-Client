//
//  ChannelsView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI

struct ChannelsView: View {
    @Bindable private var viewModel: ChannelsViewModel
    
    init(viewModel: ChannelsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
//                    ForEach(channelItems) { channelItemView(for: $0) }
                    contentView()
                } header: {
                    ZStack {
                        Rectangle()
                            .frame(height: 82)
                            .foregroundStyle(Color.white)
                        VStack {
                            Button("Create Channel") {
                            }
                            .buttonStyle(CreateChanelButtonStyle())
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            Spacer()
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
        .onAppear {
            viewModel.loadChannels()
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.loadChannelsResult {
        case .success(let channels):
            contentView(for: channels)
        case .failure(let error):
            contentView(for: error)
        }
    }
    
    @ViewBuilder
    private func contentView(for channels: [ChannelItem]) -> some View {
        if channels.isEmpty {
            noChannelsContentView()
        } else {
            channelsListContentView(for: channels)
        }
    }
    
    @ViewBuilder
    private func contentView(for error: LoadChannelsError) -> some View {
        switch error {
        case .unknown, .invalidData:
            unknownErrorContentView()
        case .connectivity:
            Text("Connectivity error")
        }
    }
    
    @ViewBuilder
    private func noChannelsContentView() -> some View {
        VStack(alignment: .center) {
            ImageProvider.noChannelsImage
                .padding(.vertical, 64)
            Text("No Channels Yet")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(ColorProvider.channelsIssueTitleColor)
                .multilineTextAlignment(.center)
            Text("Kickstart the conversation by creating the first channel!")
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(ColorProvider.channelsIssueMessageColor)
                .padding(.vertical, 8)
                .padding(.horizontal, 40)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private func channelsListContentView(for channels: [ChannelItem]) -> some View {
        ForEach(channels) { channelItemView(for: $0) }
    }
    
    @ViewBuilder
    private func unknownErrorContentView() -> some View {
        VStack(alignment: .center) {
            ImageProvider.unknownErrorOnChannelsImage
                .padding(.vertical, 64)
            Text("Oops, Something Went Wrong")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(ColorProvider.channelsIssueTitleColor)
                .multilineTextAlignment(.center)
            Text("Something unexpected happened. We're on it, but you might want to try again")
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(ColorProvider.channelsIssueMessageColor)
                .padding(.vertical, 8)
                .padding(.horizontal, 40)
                .multilineTextAlignment(.center)
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
        ChannelsView(viewModel: ChannelsViewModel(loader: FakeChannelsLoader()))
    }
}

private class FakeChannelsLoader: ChannelsLoaderProtocol {
    func load(completion: @escaping (Result<[Channel], LoadChannelsError>) -> Void) {
    }
}
