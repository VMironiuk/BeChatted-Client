//
//  ColorProvider.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 23.02.2024.
//

import SwiftUI

final class ColorProvider {
  private init() {}
  static var authHeaderColor: Color {
    assetColor(for: "Auth/Header/HeaderColor")
  }
  static var authHeaderTitleColor: Color {
    assetColor(for: "Auth/Header/TitleColor")
  }
  static var authHeaderSubtitleColor: Color {
    assetColor(for: "Auth/Header/SubtitleColor")
  }
  static var authMainButtonColor: Color {
    assetColor(for: "Auth/MainButtonColor")
  }
  static var authButtonNormalColor: Color {
    assetColor(for: "Auth/Button/NormalColor")
  }
  static var authButtonLoadingColor: Color {
    assetColor(for: "Auth/Button/LoadingColor")
  }
  static var authButtonFailedColor: Color {
    assetColor(for: "Auth/Button/FailedColor")
  }
  static var createChannelButtonForegroundColor: Color {
    assetColor(for: "Channels/CreateChannelButton/ForegroundColor")
  }
  static var createChannelButtonBorderColor: Color {
    assetColor(for: "Channels/CreateChannelButton/BorderColor")
  }
  static var authBottomLabelColor: Color {
    assetColor(for: "Auth/BottomLabelColor")
  }
  static var authUserInputBorderColor: Color {
    assetColor(for: "Auth/UserInput/BorderColor")
  }
  static var authUserInputTitleColor: Color {
    assetColor(for: "Auth/UserInput/TitleColor")
  }
  static var authRegistrationSuccessLabelColor: Color {
    assetColor(for: "Auth/SuccessLabelColor")
  }
  static var recommendedChannelsLabelColor: Color {
    assetColor(for: "Channels/RecommendedChannelsLabelColor")
  }
  static var channelItemBackgroundColor: Color {
    assetColor(for: "Channels/ChannelItemBackgroundColor")
  }
  static var channelsIssueTitleColor: Color {
    assetColor(for: "Channels/ChannelsIssueTitleColor")
  }
  static var channelsIssueMessageColor: Color {
    assetColor(for: "Channels/ChannelsIssueMessageColor")
  }
}

extension ColorProvider {
  private static func assetColor(for name: String) -> Color {
    Color(name, bundle: Bundle(for: self))
  }
}
