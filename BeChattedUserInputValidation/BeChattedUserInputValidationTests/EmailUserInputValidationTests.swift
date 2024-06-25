//
//  EmailUserInputValidationTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 23.05.2023.
//

import XCTest
import BeChattedUserInputValidation

final class EmailUserInputValidationTests: XCTestCase {
  
  func test_isValid_returnsFalseForMissingAtSymbol() {
    // given
    let email = "emailexample.com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseForTwoAtSymbols() {
    // given
    let email = "email@@example.com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseIfLocalPartStartsWithPeriod() {
    // given
    let email = ".email@example.com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseIfLocalPartEndsWithPeriod() {
    // given
    let email = "email.@example.com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseIfLocalPartStartsWithUnderscore() {
    // given
    let email = "_email@example.com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseIfLocalPartEndsWithUnderscore() {
    // given
    let email = "email_@example.com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseIfLocalPartIsLongerThan65Characters() {
    // given
    let email = "emailemailemailemailemailemailemailemailemailemailemailemailemaila@example.com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseIfDomainPartDoesNotContainPeriod() {
    // given
    let email = "email@examplecom"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseIfDomainPartContainsMoreThanOnePeriod() {
    // given
    let email = "email@example..com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseIfDomainPartContainsInvalidCharacter() {
    // given
    let email = "email@e%ample.com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseIfDomainPartContainsMoreThan255Characters() {
    // given
    let domain = Array(repeating: "example", count: 37).joined()
    let email = "email@\(domain).com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsFalseIfTLDPartContainsMoreThan63Characters() {
    // given
    let tld = Array(repeating: "com", count: 22).joined()
    let email = "email@example.\(tld)"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertFalse(sut.isValid(email: email))
  }
  
  func test_isValid_returnsTrueForValidEmail() {
    // given
    let email = "email@example.com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertTrue(sut.isValid(email: email))
  }
  
  func test_isValid_caseInsensitive() {
    // given
    let email = "Email@Example.com"
    let sut = EmailValidator()
    
    // when
    // then
    XCTAssertTrue(sut.isValid(email: email))
  }
}
