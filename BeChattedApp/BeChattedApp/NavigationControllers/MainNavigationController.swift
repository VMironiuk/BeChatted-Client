//
//  MainNavigationController.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 26.02.2024.
//

import BeChatted
import SwiftUI

final class MainNavigationController: ObservableObject {
  enum Destination: Hashable {
    case register
    case channel(ChannelItem)
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(self)
    }
  }
  
  @Published var path = NavigationPath()
  
  func popToRoot() {
    path = NavigationPath()
  }
  
  func pop() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }
  
  func goToRegister() {
    path.append(Destination.register)
  }
  
  func goToChannel(_ channelItem: ChannelItem) {
    path.append(Destination.channel(channelItem))
  }
}
