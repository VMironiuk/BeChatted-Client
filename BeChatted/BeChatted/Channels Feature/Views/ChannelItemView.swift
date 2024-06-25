//
//  ChannelItemView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 01.05.2024.
//

import SwiftUI

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
  ChannelItemView(channelName: "a name", isUnread: false)
}
