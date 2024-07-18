//
//  ChannelsView.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 18.03.2024.
//

import SwiftUI
import BeChatted

struct ChannelsView<CreateChannelContent: View, UserProfileContent: View>: View {
  @ObservedObject private var viewModel: ChannelsViewModel
  private let createChannelContent: CreateChannelContent
  private let userProfileContent: UserProfileContent
  private let onChannelTap: (ChannelItem) -> Void
  
  @State private var isCreateChannelContentPresented = false
  @State private var isUserProfileContentPresented = false
  
  init(
    viewModel: ChannelsViewModel,
    createChannelContent: CreateChannelContent,
    userProfileContent: UserProfileContent,
    onChannelTap: @escaping (ChannelItem) -> Void
  ) {
    self.viewModel = viewModel
    self.createChannelContent = createChannelContent
    self.userProfileContent = userProfileContent
    self.onChannelTap = onChannelTap
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
          isUserProfileContentPresented.toggle()
        } label: {
          ImageProvider.avatarPrototype
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
      }
    }
    .onAppear {
      viewModel.loadChannels()
    }
    .refreshable {
      viewModel.loadChannels()
    }
    .sheet(isPresented: $isCreateChannelContentPresented) {
      createChannelContent
    }
    .sheet(isPresented: $isUserProfileContentPresented) {
      userProfileContent
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
  
  @ViewBuilder
  private func channelsListContentView(for channels: [ChannelItem]) -> some View {
    ChannelTitleView()
    ForEach(channels) { channelItemView(for: $0) }
  }
  
  private func channelItemView(for channelItem: ChannelItem) -> some View {
    ChannelItemView(channelName: channelItem.name, isUnread: false)
      .onTapGesture {
        onChannelTap(channelItem)
      }
  }
}

#Preview {
  NavigationStack {
    ChannelsView(
      viewModel: ChannelsViewModel(
        channelsLoadingService: FakeChannelsLoadingService()
      ),
      createChannelContent: Text("Hello"),
      userProfileContent: Text("Profile"),
      onChannelTap: { _ in }
    )
  }
}

private class FakeChannelsLoadingService: ChannelsLoadingServiceProtocol {
  func loadChannels(
    completion: @escaping (Result<[Channel], ChannelsLoadingServiceError>) -> Void
  ) {
  }
}
