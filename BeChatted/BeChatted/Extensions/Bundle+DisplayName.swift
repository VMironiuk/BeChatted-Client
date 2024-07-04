//
//  Bundle+DisplayName.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.12.2023.
//

import Foundation

extension Bundle {
  var displayName: String? {
    object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
  }
  
  var displayNameOrEmpty: String {
    displayName ?? ""
  }
}
