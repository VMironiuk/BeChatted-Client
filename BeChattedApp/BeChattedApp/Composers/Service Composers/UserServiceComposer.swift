//
//  UserServiceComposer.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 10.07.2024.
//

import Foundation
import BeChattedNetwork
import BeChattedUser

struct UserServiceComposer {
  private init() {}
  
  private static let baseURLString = URLProvider.baseURLString
  
  private static let userByEmailEndpoint = "/v1/user/byEmail"
  
  private static let userByEmailURL = URL(string: "\(baseURLString)\(userByEmailEndpoint)")!
  
  static let userService = UserService(url: userByEmailURL, client: URLSessionHTTPClient())
}
