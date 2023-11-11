//
//  LoginViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import XCTest
import BeChattedUserInputValidation

final class LoginViewModel {
    private let emailValidator: EmailValidatorProtocol
    private let passwordValidator: PasswordValidatorProtocol
    
    var email: String = ""
    var password: String = ""
    var isUserInputValid: Bool {
        emailValidator.isValid(email: email) && passwordValidator.isValid(password: password)
    }
    
    init(emailValidator: EmailValidatorProtocol, passwordValidator: PasswordValidatorProtocol) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
    }
}

final class LoginViewModelTests: XCTestCase {

    func test_init_containsNonValidUserInput() {
        XCTAssertFalse(makeSUT().isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyPassword() {
        let sut = makeSUT()
        
        sut.email = "mail@example.com"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyEmail() {
        let sut = makeSUT()
        
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidEmailFormat() {
        let sut = makeSUT()
        
        sut.email = "emailexample.com"
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidPasswordFormat() {
        let sut = makeSUT()
        
        sut.email = "emailexample.com"
        sut.password = "1234"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsTrueOnValidCredentials() {
        let sut = makeSUT()
        
        sut.email = "mail@example.com"
        sut.password = "0123456789"
        
        XCTAssertTrue(sut.isUserInputValid)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> LoginViewModel {
        let emailValidator = EmailValidator()
        let passwordValidator = PasswordValidator()
        let sut = LoginViewModel(emailValidator: emailValidator, passwordValidator: passwordValidator)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
