//
//  URLSessionHTTPClientWrapper.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 11.10.2024.
//

import BeChattedAuth
import BeChattedChannels
import BeChattedMessaging
import BeChattedNetwork
import BeChattedUser

struct URLSessionHTTPClientWrapper {
  let underlyingHTTPClient: URLSessionHTTPClient
  
  func perform(
    request: URLRequest,
    completion: @escaping (Result<(Data?, HTTPURLResponse?), any Error>) -> Void
  ) {
    underlyingHTTPClient.perform(request: request, completion: completion)
  }
}

extension URLSessionHTTPClientWrapper: BeChattedAuth.HTTPClientProtocol {}

extension URLSessionHTTPClientWrapper: BeChattedChannels.HTTPClientProtocol {}

extension URLSessionHTTPClientWrapper: BeChattedUser.HTTPClientProtocol {}

extension URLSessionHTTPClientWrapper: BeChattedMessaging.HTTPClientProtocol {}
