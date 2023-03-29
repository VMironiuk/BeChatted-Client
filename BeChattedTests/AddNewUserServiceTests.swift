//
//  AddNewUserServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 28.03.2023.
//

import XCTest

final class AddNewUserServiceTests: XCTestCase {

    // 1. init() does not send new user payload by URL
    // 2. send() sends new user payload by URL
    // 3. send() sends new user payload by URL twice
    // 4. send() delivers connectivity error on client error
    // 5. send() delivers server error on 500 HTTP response
    // 6. send() delivers unknown error on non 200 HTTP response
    // 7. send() delivers invalid data error on 200 HTTP response with invalid body
    // 8. send() does not deliver result on client error after instance has been deallocated
    // 9. send() does not deliver result on 500 HTTP response after instance has been deallocated
    // 10. send() does not deliver result on non 200 HTTP response after instance has been deallocated
    // 11. send() does not deliver result on 200 HTTP response after instance has been deallocated
    // 12. send() delivers new user info on 200HTTP response with valid body
}
