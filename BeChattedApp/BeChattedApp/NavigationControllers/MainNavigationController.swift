//
//  MainNavigationController.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 26.02.2024.
//

import SwiftUI

@Observable final class MainNavigationController {
    enum Destination {
        case register
    }
    
    var path = NavigationPath()
    
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
