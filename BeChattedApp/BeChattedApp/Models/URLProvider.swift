//
//  URLProvider.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 28.06.2024.
//

import Foundation

enum URLProvider {
  private static let httpProtocol = "http"
  private static let host = "localhost"
  private static let port = "3005"
  
  static let baseURLString = "\(httpProtocol)://\(host):\(port)"
}
