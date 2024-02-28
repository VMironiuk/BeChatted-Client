//
//  UIApplication+HideKeyboard.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.02.2024.
//

import UIKit

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
