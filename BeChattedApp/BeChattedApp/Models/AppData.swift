//
//  AppData.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 28.02.2024.
//

import Foundation

final class AppData: ObservableObject {
  @Published var isUserLoggedIn: Bool = false
  @Published var authToken: String?
}
