//
//  LoginViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import XCTest
import BeChatted
import BeChattedUserInputValidation

final class LoginViewModelTests: XCTestCase {

    func test_init_containsNonValidUserInput() {
        let (sut, _) = makeSUT()
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyPassword() {
        let (sut, _) = makeSUT()
        
        sut.email = "mail@example.com"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyEmail() {
        let (sut, _) = makeSUT()
        
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidEmailFormat() {
        let (sut, _) = makeSUT()
        
        sut.email = "emailexample.com"
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidPasswordFormat() {
        let (sut, _) = makeSUT()
        
        sut.email = "email@example.com"
        sut.password = "1234"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsTrueOnValidCredentials() {
        let (sut, _) = makeSUT()
        
        sut.email = "mail@example.com"
        sut.password = "0123456789"
        
        XCTAssertTrue(sut.isUserInputValid)
    }
    
    func tests_init_doesNotSendMessagesToAuthService() {
        let (_, authService) = makeSUT()
        
        XCTAssertEqual(authService.createAccountCallCount, 0)
        XCTAssertEqual(authService.addUserCallCount, 0)
        XCTAssertEqual(authService.loginCallCount, 0)
        XCTAssertEqual(authService.logoutCallCount, 0)
    }
    
    func test_login_sendsOnlyOneLoginMessageToAuthServiceOnOneCall() {
        let (sut, authService) = makeSUT()
        
        sut.login()
        
        XCTAssertEqual(authService.createAccountCallCount, 0)
        XCTAssertEqual(authService.addUserCallCount, 0)
        XCTAssertEqual(authService.loginCallCount, 1)
        XCTAssertEqual(authService.logoutCallCount, 0)
    }

    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (LoginViewModel, AuthServiceStub) {
        let emailValidator = EmailValidator()
        let passwordValidator = PasswordValidator()
        let authService = AuthServiceStub()
        let sut = LoginViewModel(
            emailValidator: emailValidator,
            passwordValidator: passwordValidator,
            authService: authService
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, authService)
    }
}
