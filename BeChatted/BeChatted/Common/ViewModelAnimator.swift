//
//  ViewModelAnimator.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.05.2024.
//

import SwiftUI

public struct ViewModelAnimator: AnimatorProtocol {
  public init() {}
  
  public func perform(action: () -> Void, completion: @escaping () -> Void) {
    withAnimation {
      action()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      withAnimation {
        completion()
      }
    }
  }
}
