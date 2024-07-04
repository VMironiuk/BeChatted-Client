//
//  HelperFunctions.swift
//  BeChattedAuthTests
//
//  Created by Volodymyr Myroniuk on 01.11.2023.
//

import Foundation
import BeChattedAuth

func anyNewAccountPayload() -> NewAccountPayload {
  NewAccountPayload(email: "my@example.com", password: "123456")
}

func anyNewUserPayload() -> NewUserPayload {
  NewUserPayload(
    name: "user name",
    email: "user@example.com",
    avatarName: "avatar name",
    avatarColor: "avatar color")
}

func anyUserLoginPayload() -> UserLoginPayload {
  UserLoginPayload(email: "my@example.com", password: "123456")
}

func anyNSError() -> NSError {
  NSError(domain: "any error", code: 1)
}

func anyURL() -> URL {
  URL(string: "http://any-url.com")!
}

func anyData() -> Data {
  "any data".data(using: .utf8)!
}

func httpResponse(withStatusCode statusCode: Int) -> HTTPURLResponse {
  HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
