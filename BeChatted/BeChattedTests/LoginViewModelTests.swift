//
//  LoginViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import XCTest
import BeChattedUserInputValidation

final class LoginViewModel {
    private let emailValidator: UserInputValidatorProtocol = EmailValidator()
    private let passwordValidator: UserInputValidatorProtocol = PasswordValidator()
    
    var email: String = ""
    var password: String = ""
    var isUserInputValid: Bool {
        emailValidator.isValid(email) && passwordValidator.isValid(password)
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
    
    func test_isUserInputValid_returnsTrueOnValidCredentials() {
        let sut = LoginViewModel()
        
        sut.email = "mail@example.com"
        sut.password = "0123456789"
        
        XCTAssertTrue(sut.isUserInputValid)
    }
}
