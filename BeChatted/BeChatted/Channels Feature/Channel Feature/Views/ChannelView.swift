//
//  ChannelView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 13.07.2024.
//

import BeChatted
import Combine
import SwiftUI

struct ChannelView: View {
  @ObservedObject var viewModel: ChannelViewModel
  
  @FocusState private var isMessageTextFieldFocused: Bool
  @State private var messageText = ""
  
  private var messages: [MessageInfo] {
    (try? viewModel.status.get()) ?? []
  }
  
  var body: some View {
    VStack {
      contentView
      bottomView
    }
    .toolbarRole(.editor)
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("# \(viewModel.channelItem.name)")
    .onAppear {
      viewModel.loadMessages()
    }
  }
}

extension ChannelView {
  private var contentView: some View {
    ScrollView(.vertical) {
      Group {
        Text("# \(viewModel.channelItem.name)")
          .font(.system(size: 24, weight: .semibold))
          .padding(.bottom, 16)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text(viewModel.channelItem.description)
          .font(.system(size: 16, weight: .regular))
          .opacity(0.6)
          .padding(.bottom, 32)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        ScrollViewReader { scrollReader in
          ForEach(messages) { message in
            MessageView(message: message)
              .padding(.bottom, 16)
          }
          .onChange(of: messages.count) {
            guard let lastMessage = messages.last else { return }
            scrollReader.scrollTo(lastMessage.id, anchor: .bottomTrailing)
          }
        }
      }
      .padding(.horizontal)
    }
    .onTapGesture {
      isMessageTextFieldFocused = false
    }
  }
  
  private var bottomView: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .bottom) {
        TextField("Message", text: $messageText, axis: .vertical)
          .textFieldStyle(.roundedBorder)
          .lineLimit(10)
          .focused($isMessageTextFieldFocused)
        
        Spacer(minLength: 16)
        
        Button {
          viewModel.sendMessage(
            MessagePayload(
              body: messageText,
              userID: viewModel.currentUser.id,
              channelID: viewModel.channelItem.id,
              userName: viewModel.currentUser.name,
              userAvatar: "",
              userAvatarColor: ""
            )
          )
          messageText = ""
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

private struct FakeMessagingService: MessagingServiceProtocol {
  var newMessage: PassthroughSubject<MessageData, Never> {
    PassthroughSubject()
  }
  
  func loadMessages(
    by channelID: String,
    completion: @escaping (Result<[MessageInfo], MessagingServiceError>) -> Void
  ) {
  }
  
  func sendMessage(_ message: MessagePayload) {
  }
}

#Preview {
  NavigationStack {
    ChannelView(
      viewModel: ChannelViewModel(
        currentUser: User(id: "ID", name: "NAME"),
        channelItem: ChannelItem(
          id: "id",
          name: "channel-name",
          description: "Channel description"
        ),
        messagingService: FakeMessagingService()
      )
    )
  }
}
