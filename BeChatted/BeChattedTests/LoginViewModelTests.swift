//
//  LoginViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import XCTest

final class LoginViewModel {
    var isUserInputValid: Bool {
        false
    }
}

final class LoginViewModelTests: XCTestCase {

    func test_init_containsNonValidUserInput() {
        let sut = LoginViewModel()
        
        
        XCTAssertFalse(sut.isUserInputValid)
    }
}
