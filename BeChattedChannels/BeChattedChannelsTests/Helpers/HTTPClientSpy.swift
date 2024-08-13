//
//  HTTPClientSpy.swift
//  BeChattedChannelsTests
//
//  Created by Volodymyr Myroniuk on 22.05.2024.
//

import BeChattedChannels

final class HTTPClientSpy: HTTPClientProtocol {
  private var messages = [(request: URLRequest, completion: (Result<(Data?, HTTPURLResponse?), Error>) -> Void)]()
  
  var requestedURLs: [URL] {
    messages.compactMap { $0.request.url }
  }
  
  var httpMethods: [String] {
    messages.compactMap { $0.request.httpMethod }
  }
  
  var contentTypes: [String] {
    messages.compactMap { $0.request.value(forHTTPHeaderField: "Content-Type") }
  }
  
  var authTokens: [String] {
    messages.compactMap { $0.request.value(forHTTPHeaderField: "Authorization") }
  }
  
  func perform(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void) {
    messages.append((request, completion))
  }
  
  func complete(with error: Error, at index: Int = 0) {
    messages[index].completion(.failure(error))
  }
  
  func complete(with response: HTTPURLResponse, at index: Int = 0) {
    messages[index].completion(.success((nil, response)))
  }
  
  func complete(with data: Data, at index: Int = 0) {
    let response = HTTPURLResponse(url: URL(string: "http://any-url.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    messages[index].completion(.success((data, response)))
  }
}
