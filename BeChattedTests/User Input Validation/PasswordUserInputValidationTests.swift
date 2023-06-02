//
//  PasswordUserInputValidationTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 02.06.2023.
//

import XCTest

struct PasswordValidator {
    func isValid(_ password: String) -> Bool {
        false
    }
}

final class PasswordUserInputValidationTests: XCTestCase {
    
    func test_isValid_returnsFalseIfPasswordIsLessThan8CharactersLong() {
        // given
        let password = "1234"
        let sut = PasswordValidator()
        
        // when
        // then
        XCTAssertFalse(sut.isValid(password))
    }
    
    func test_isValid_returnsFalseIfPasswordIsEmpty() {
        // given
        let password = ""
        let sut = PasswordValidator()
        
        // when
        // then
        XCTAssertFalse(sut.isValid(password))
    }
    
    func test_isValid_returnsFalseIfPasswordHasLeadingSpace() {
        // given
        let password = " 12345678"
        let sut = PasswordValidator()
        
        // when
        // then
        XCTAssertFalse(sut.isValid(password))
    }
    
    func test_isValid_returnsFalseIfPasswordHasTrailingSpace() {
        // given
        let password = "12345678 "
        let sut = PasswordValidator()
        
        // when
        // then
        XCTAssertFalse(sut.isValid(password))
    }
}
