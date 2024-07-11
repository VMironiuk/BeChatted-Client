//
//  User+UserInfo.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 11.07.2024.
//

import BeChatted

extension User {
  init(from userInfo: UserInfo) {
    self.init(
      id: userInfo.id,
      name: userInfo.name,
      email: userInfo.email
    )
  }
}
