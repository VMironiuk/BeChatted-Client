//
//  AnimatorProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.05.2024.
//

import Foundation

public protocol AnimatorProtocol {
  func perform(action: () -> Void, completion: @escaping () -> Void)
}
