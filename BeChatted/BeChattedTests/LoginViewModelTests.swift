//
//  LoginViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import XCTest
import BeChatted
import BeChattedAuth
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
        
        sut.login { _ in }
        
        XCTAssertEqual(authService.createAccountCallCount, 0)
        XCTAssertEqual(authService.addUserCallCount, 0)
        XCTAssertEqual(authService.loginCallCount, 1)
        XCTAssertEqual(authService.logoutCallCount, 0)
    }
    
    func test_login_sendsOnlyTwoLoginMessagesToAuthServiceOnTwoCalls() {
        let (sut, authService) = makeSUT()
        
        sut.login { _ in }
        sut.login { _ in }
        
        XCTAssertEqual(authService.createAccountCallCount, 0)
        XCTAssertEqual(authService.addUserCallCount, 0)
        XCTAssertEqual(authService.loginCallCount, 2)
        XCTAssertEqual(authService.logoutCallCount, 0)
    }
    
    func test_login_failsIfAuthServiceLoginRequestFails() {
        let (sut, authService) = makeSUT()
        let credentialsLoginError = LoginErrorMapper.error(for: .credentials)
        let exp = expectation(description: "Wait for login request completion")
        
        sut.login { result in
            switch result {
            case .success:
                XCTFail("Expected error, got \(result) instead")
            case let .failure(receivedError):
                XCTAssertEqual(receivedError, credentialsLoginError)
            }
            exp.fulfill()
        }
        
        authService.completeLogin(with: .credentials)
        wait(for: [exp], timeout: 1)
    }

    func test_login_succeedsIfAuthServiceLoginRequestSucceeds() {
        let (sut, authService) = makeSUT()
        let exp = expectation(description: "Wait for login request completion")
        
        sut.login { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail("Expected success, got \(result) instead")
            }
            exp.fulfill()
        }
        
        authService.completeLoginSuccessfully()
        wait(for: [exp], timeout: 1)
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
    
    func anyNSError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
}
