//
//  UserLogoutServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 07.04.2023.
//

import XCTest

final class UserLogoutServiceTests: XCTestCase {
    
    // 1. init() does not send a request by URL
    // 2. send() sends logout request by URL
    // 3. send() sends logout request by URL twice
    // 4. send() delivers connectivity error on client error
    // 5. send() does not deliver result after the instance has been deallocated
    // 6. send() delivers successful result on any HTTP response
}
