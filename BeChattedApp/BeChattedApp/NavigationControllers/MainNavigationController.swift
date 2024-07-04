//
//  MainNavigationController.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 26.02.2024.
//

import SwiftUI

final class MainNavigationController: ObservableObject {
  enum Destination {
    case register
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
}
