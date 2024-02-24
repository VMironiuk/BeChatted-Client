//
//  Bundle+DisplayName.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 24.02.2024.
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
