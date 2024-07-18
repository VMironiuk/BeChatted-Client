//
//  ChannelsLoadingIssueContentView.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 01.05.2024.
//

import SwiftUI

enum ChannelsLoadingIssue {
  case empty
  case unknown
  case connectivity
}

struct ChannelsLoadingIssueContentView: View {
  let issue: ChannelsLoadingIssue
  
  private var image: Image {
    switch issue {
    case .empty: ImageProvider.noChannelsImage
    case .unknown: ImageProvider.unknownErrorOnChannelsImage
    case .connectivity: ImageProvider.connectivityIssueOnChannelsImage
    }
  }
  
  private var title: String {
    switch issue {
    case .empty: "No Channels Yet"
    case .unknown: "Oops, Something Went Wrong"
    case .connectivity: "Oops, Connection Trouble!"
    }
  }
  
  private var description: String {
    switch issue {
    case .empty: "Kickstart the conversation by creating the first channel!"
    case .unknown: "Something unexpected happened. We're on it, but you might want to try again"
    case .connectivity: "We're having trouble connecting right now. Please check your internet connection or try again later"
    }
  }
  
  var body: some View {
    VStack(alignment: .center) {
      image
        .padding(.vertical, 64)
      Text(title)
        .font(.system(size: 24, weight: .semibold))
        .foregroundStyle(ColorProvider.channelsIssueTitleColor)
        .multilineTextAlignment(.center)
      Text(description)
        .font(.system(size: 20, weight: .regular))
        .foregroundStyle(ColorProvider.channelsIssueMessageColor)
        .padding(.vertical, 8)
        .padding(.horizontal, 40)
        .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  ChannelsLoadingIssueContentView(issue: .empty)
}
