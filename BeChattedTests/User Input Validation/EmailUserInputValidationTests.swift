//
//  EmailUserInputValidationTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 23.05.2023.
//

import XCTest

struct EmailValidator {
    func isValid(_ email: String) -> Bool {
        false
    }
}

final class EmailUserInputValidationTests: XCTestCase {

    func test_isValid_returnsFalseForMissingAtSymbol() {
        // given
        let email = "emailexample.com"
        let sut = EmailValidator()
        
        // when
        // then
        XCTAssertFalse(sut.isValid(email))
    }
    
    func test_isValid_returnsFalseForTwoAtSymbols() {
        // given
        let email = "email@@example.com"
        let sut = EmailValidator()
        
        // when
        // then
        XCTAssertFalse(sut.isValid(email))
    }
    
    func test_isValid_returnsFalseIfLocalPartStartsWithPeriod() {
        // given
        let email = ".email@example.com"
        let sut = EmailValidator()

        // when
        // then
        XCTAssertFalse(sut.isValid(email))
    }
    
    func test_isValid_returnsFalseIfLocalPartEndsWithPeriod() {
        // given
        let email = "email.@example.com"
        let sut = EmailValidator()

        // when
        // then
        XCTAssertFalse(sut.isValid(email))
    }
    
    func test_isValid_returnsFalseIfLocalPartStartsWithUnderscore() {
        // given
        let email = "_email@example.com"
        let sut = EmailValidator()

        // when
        // then
        XCTAssertFalse(sut.isValid(email))
    }
}
