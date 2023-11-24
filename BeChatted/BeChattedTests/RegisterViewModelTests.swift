//
//  RegisterViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import XCTest
import BeChatted
import BeChattedUserInputValidation

final class RegisterViewModelTests: XCTestCase {

    func test_init_containsNonValidUserInput() {
        XCTAssertFalse(makeSUT().isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyName() {
        let sut = makeSUT()
        
        sut.email = "mail@example.com"
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyEmail() {
        let sut = makeSUT()
        
        sut.name = "Jonny B"
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyPassword() {
        let sut = makeSUT()
        
        sut.name = "Jonny B"
        sut.email = "mail@example.com"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidEmailFormat() {
        let sut = makeSUT()
        
        sut.name = "Jonny B"
        sut.email = "emailexample.com"
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }

    func test_isUserInputValid_returnsFalseOnInvalidPasswordFormat() {
        let sut = makeSUT()
        
        sut.name = "Jonny B"
        sut.email = "email@example.com"
        sut.password = "1234"
        
        XCTAssertFalse(sut.isUserInputValid)
    }

    func test_isUserInputValid_returnsTrueOnValidCredentials() {
        let sut = makeSUT()
        
        sut.name = "Jonny B"
        sut.email = "mail@example.com"
        sut.password = "0123456789"
        
        XCTAssertTrue(sut.isUserInputValid)
    }

    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> RegisterViewModel {
        let emailValidator = EmailValidator()
        let passwordValidator = PasswordValidator()
        let authService = AuthServiceStub()
        let sut = RegisterViewModel(
            emailValidator: emailValidator,
            passwordValidator: passwordValidator,
            authService: authService
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
