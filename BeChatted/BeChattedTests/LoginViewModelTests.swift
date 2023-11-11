//
//  LoginViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import XCTest

final class LoginViewModel {
    var email: String = ""
    var password: String = ""
    var isUserInputValid: Bool {
        false
    }
}

final class LoginViewModelTests: XCTestCase {

    func test_init_containsNonValidUserInput() {
        let sut = LoginViewModel()
        
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyPassword() {
        let sut = LoginViewModel()
        
        sut.email = "mail@example.com"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyEmail() {
        let sut = LoginViewModel()
        
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidEmailFormat() {
        let sut = LoginViewModel()
        
        sut.email = "emailexample.com"
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidPasswordFormat() {
        let sut = LoginViewModel()
        
        sut.email = "emailexample.com"
        sut.password = "1234"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
}
