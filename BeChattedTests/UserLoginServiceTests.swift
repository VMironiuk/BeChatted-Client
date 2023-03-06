//
//  UserLoginServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 06.03.2023.
//

import XCTest

final class UserLoginServiceTests: XCTestCase {
    
    // 1. init() does not send user login payload by URL
    // 2. send() sends user login payload by URL
    // 3. call send() twice sends user login payload by URL twice
    // 4. send() delivers connectivity error if there is no connectivity
    // 5. send() delivers invalid credentials error on 401 HTTP response
    // 6. send() delivers server error on 500...599 HTTP response
    // 7. send() delivers unknown error on non 200, 401 and 500...599 HTTP responses
    // 8. send() delivers invalid data error on 200 HTTP response with invalid responses body
    // 9. send() does not send user login payload if instance has been deallocated
    // 10. send() delivers user(name) and token on 200 HTTP response
}
