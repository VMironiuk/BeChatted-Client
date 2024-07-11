//
//  UserProfileInfo+User.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 11.07.2024.
//

import BeChatted

extension UserProfileInfo {
  init(from user: User?) {
    self.init(
      name: user?.name ?? "Unknown",
      email: user?.email ?? "Unknown"
    )
  }
}
