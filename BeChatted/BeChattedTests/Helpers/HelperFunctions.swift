//
//  HelperFunctions.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 02.04.2024.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 1)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    "any data".data(using: .utf8)!
}
