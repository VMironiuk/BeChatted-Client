//
//  MainNavigationController.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 14.02.2024.
//

import SwiftUI

enum Destination {
    case register
}

final class MainNavigationController: ObservableObject {
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
