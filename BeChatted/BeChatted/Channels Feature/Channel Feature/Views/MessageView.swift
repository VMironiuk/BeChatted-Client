//
//  MessageView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 17.07.2024.
//

import BeChatted
import SwiftUI

struct MessageView: View {
  let message: MessageInfo
  
  var body: some View {
    HStack(alignment: .top) {
      ImageProvider.avatarPrototype
        .clipShape(RoundedRectangle(cornerRadius: 12))
      
      VStack {
        HStack {
          Text(message.userName)
            .font(.system(size: 20, weight: .bold))
          
          Text(message.timeStamp)
            .font(.system(size: 14))
            .opacity(0.5)
          
          Spacer()
        }
        .padding(.bottom, 2)
        
        Text(message.messageBody)
      }
    }
  }
}

#Preview {
  MessageView(
    message: MessageInfo(
      id: "ID",
      messageBody: "Message body goes her",
      userId: "user ID",
      channelId: "channel ID",
      userName: "John Doe",
      userAvatar: "avatar",
      userAvatarColor: "avatar color",
      timeStamp: "08:33 AM"
    )
  )
}
