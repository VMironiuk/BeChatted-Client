//
//  AppData.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 28.02.2024.
//

import Foundation

final class AppData: ObservableObject {
  @Published var currentUser: User?
  @Published var authToken: String?
  
  var isUserLoggedIn: Bool {
    currentUser != nil
  }
}
