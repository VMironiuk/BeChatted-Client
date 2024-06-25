//
//  HTTPClientProtocol.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 22.05.2024.
//

import Foundation

public protocol HTTPClientProtocol {
  func perform(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void)
}
