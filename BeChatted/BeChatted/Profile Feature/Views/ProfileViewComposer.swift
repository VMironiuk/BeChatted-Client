//
//  ProfileViewComposer.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 28.06.2024.
//

import SwiftUI
import BeChatted

public enum ProfileViewComposer {
  public static func composedProfileView(
    viewModel: ProfileViewModel
  ) -> some View {
    ProfileView(viewModel: viewModel)
  }
}
