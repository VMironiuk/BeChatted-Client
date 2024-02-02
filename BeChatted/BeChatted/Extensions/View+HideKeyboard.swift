//
//  View+HideKeyboard.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.02.2024.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
