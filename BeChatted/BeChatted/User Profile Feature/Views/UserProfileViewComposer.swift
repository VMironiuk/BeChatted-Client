//
//  UserProfileViewComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 28.06.2024.
//

import SwiftUI
import BeChatted

public enum UserProfileViewComposer {
  public static func composedProfileView(
    viewModel: UserProfileViewModel
  ) -> some View {
    UserProfileView(viewModel: viewModel)
  }
}
