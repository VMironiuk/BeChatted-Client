//
//  ImageProvider.swift
//  BeChattediOS
//
//  Created by Volodymyr Myroniuk on 24.02.2024.
//

import SwiftUI

final class ImageProvider {
  private init() {}
  
  static var authRegistrationSuccessImage: Image {
    assetImage(for: "Auth/RegistrationSuccessIcon")
  }
  
  static var noChannelsImage: Image {
    assetImage(for: "Channels/NoChannelsImage")
  }
  
  static var unknownErrorOnChannelsImage: Image {
    assetImage(for: "Channels/UnknownErrorOnChannelsImage")
  }
  
  static var connectivityIssueOnChannelsImage: Image {
    assetImage(for: "Channels/ConnectionIssueImage")
  }
  
  static var avatarPrototype: Image {
    assetImage(for: "AvatarPrototype")
  }
  
  static var createChannelSuccessImage: Image {
    assetImage(for: "Channels/CreateChannelSuccessIcon")
  }
}

private extension ImageProvider {
  private static func assetImage(for name: String) -> Image {
    Image(name, bundle: Bundle(for: self))
  }
}
