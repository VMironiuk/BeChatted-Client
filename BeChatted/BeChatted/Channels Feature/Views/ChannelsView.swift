//
//  ChannelsView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI
import BeChatted

struct ChannelsView<Content: View>: View {
    @ObservedObject private var viewModel: ChannelsViewModel
    private let createChannelContent: Content
    
    @State private var isCreateChannelContentPresented = false
    
    init(viewModel: ChannelsViewModel, createChannelContent: Content) {
        self.viewModel = viewModel
        self.createChannelContent = createChannelContent
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
                    contentView()
                } header: {
                    ZStack {
                        Rectangle()
                            .frame(height: 82)
                            .foregroundStyle(Color.white)
                        VStack {
                            Button("Create Channel") {
                                isCreateChannelContentPresented = true
                            }
                            .buttonStyle(SecondaryButtonStyle())
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
//            viewModel.loadChannels()
        }
        .refreshable {
//            viewModel.loadChannels()
        }
        .sheet(isPresented: $isCreateChannelContentPresented) {
            createChannelContent
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
//        switch viewModel.loadChannelsResult {
//        case .success(let channels):
//            contentView(for: channels)
//        case .failure(let error):
//            contentView(for: error)
//        }
        contentView(for: [])
    }
    
    @ViewBuilder
    private func contentView(for channels: [ChannelItem]) -> some View {
        if channels.isEmpty {
            ChannelsLoadingIssueContentView(issue: .empty)
        } else {
            channelsListContentView(for: channels)
        }
    }
    
    private func contentView(for error: ChannelsLoadingServiceError) -> some View {
        switch error {
        case .unknown, .invalidData: ChannelsLoadingIssueContentView(issue: .unknown)
        case .connectivity: ChannelsLoadingIssueContentView(issue: .connectivity)
        }
    }
        
    private func channelsListContentView(for channels: [ChannelItem]) -> some View {
        ForEach(channels) { channelItemView(for: $0) }
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

#Preview {
    NavigationStack {
        ChannelsView(
            viewModel: ChannelsViewModel(
                channelsLoadingService: FakeChannelsLoadingService()
            ),
            createChannelContent: Text("Hello")
        )
    }
}

private class FakeChannelsLoadingService: ChannelsLoadingServiceProtocol {
    func loadChannels(completion: @escaping (Result<[Channel], ChannelsLoadingServiceError>) -> Void) {
    }
}
