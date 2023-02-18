//
//  NewAccountInfoSenderTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 18.02.2023.
//

import XCTest

final class NewAccountInfoSenderTests: XCTestCase {

    // 1. init() does not send a new account info by url
    
    // 2. send() sends a new account info by url
    
    // 3. call send() twice sends a new account info by url twice
    
    // 4. send() delivers error on client error (no connectivity error)
    
    // 5. send() delivers error on non 200 HTTP response
    
    // 6. send() delivers successful result on 200 HTTP response
    
    // 7. send() does not delivers result after SUT instance has been deallocated
}
