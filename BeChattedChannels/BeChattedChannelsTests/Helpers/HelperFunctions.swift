//
//  HelperFunctions.swift
//  BeChattedChannelsTests
//
//  Created by Volodymyr Myroniuk on 22.05.2024.
//

import Foundation

func anyURL() -> URL {
  URL(string: "http://any-url.com")!
}

func anyAuthToken() -> String {
  "any token"
}

func httpResponse(with statusCode: Int) -> HTTPURLResponse {
  HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
