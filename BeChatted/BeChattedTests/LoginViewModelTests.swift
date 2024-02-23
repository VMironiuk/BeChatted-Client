//
//  LoginViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import XCTest
import BeChatted

final class LoginViewModelTests: XCTestCase {

    func test_init_containsNonValidUserInput() {
        let (sut, _) = makeSUT(isEmailValidStub: false, isPasswordValidStub: false)
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidPassword() {
        let (sut, _) = makeSUT(isEmailValidStub: true, isPasswordValidStub: false)
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidEmail() {
        let (sut, _) = makeSUT(isEmailValidStub: false, isPasswordValidStub: true)
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsTrueOnValidCredentials() {
        let (sut, _) = makeSUT(isEmailValidStub: true, isPasswordValidStub: true)
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
        let unknownLoginError = AuthError.unknown
        let exp = expectation(description: "Wait for login request completion")
        
        sut.login { result in
            switch result {
            case .success:
                XCTFail("Expected error, got \(result) instead")
            case let .failure(receivedError):
                XCTAssertEqual(receivedError, unknownLoginError)
            }
            exp.fulfill()
        }
        
        authService.completeLoginWithError(.unknown)
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
    
    private func makeSUT(
        isEmailValidStub: Bool = false,
        isPasswordValidStub: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LoginViewModel, AuthServiceStub) {
        let emailValidator = EmailValidatorStub(isValidStubbed: isEmailValidStub)
        let passwordValidator = PasswordValidatorStub(isValidStubbed: isPasswordValidStub)
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
