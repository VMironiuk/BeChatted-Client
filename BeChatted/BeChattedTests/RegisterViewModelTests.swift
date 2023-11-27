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
        let (sut, _) = makeSUT()
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyName() {
        let (sut, _) = makeSUT()
        
        sut.email = "mail@example.com"
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyEmail() {
        let (sut, _) = makeSUT()
        
        sut.name = "Jonny B"
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyPassword() {
        let (sut, _) = makeSUT()
        
        sut.name = "Jonny B"
        sut.email = "mail@example.com"
        
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidEmailFormat() {
        let (sut, _) = makeSUT()
        
        sut.name = "Jonny B"
        sut.email = "emailexample.com"
        sut.password = "0123456789"
        
        XCTAssertFalse(sut.isUserInputValid)
    }

    func test_isUserInputValid_returnsFalseOnInvalidPasswordFormat() {
        let (sut, _) = makeSUT()
        
        sut.name = "Jonny B"
        sut.email = "email@example.com"
        sut.password = "1234"
        
        XCTAssertFalse(sut.isUserInputValid)
    }

    func test_isUserInputValid_returnsTrueOnValidCredentials() {
        let (sut, _) = makeSUT()
        
        sut.name = "Jonny B"
        sut.email = "mail@example.com"
        sut.password = "0123456789"
        
        XCTAssertTrue(sut.isUserInputValid)
    }
    
    func test_init_doesNotSendMessagesToAuthService() {
        let (_, authService) = makeSUT()
        
        XCTAssertEqual(authService.createAccountCallCount, 0)
        XCTAssertEqual(authService.addUserCallCount, 0)
        XCTAssertEqual(authService.loginCallCount, 0)
        XCTAssertEqual(authService.logoutCallCount, 0)
    }
    
    func test_register_failsIfAuthServiceCreateAccountRequestFails() {
        let (sut, authService) = makeSUT()
        let createAccountError: NSError = anyNSError()
        
        let exp = expectation(description: "Wait for registration completion")
        var receivedError: NSError?
        sut.register { result in
            switch result {
            case .success:
                XCTFail("Expected registration to fail, got \(result) instead")
            case .failure(let error):
                receivedError = error as NSError
            }
            exp.fulfill()
        }
        
        authService.completeCreateAccount(with: createAccountError)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError, createAccountError)
        XCTAssertEqual(authService.createAccountCallCount, 1)
        XCTAssertEqual(authService.addUserCallCount, 0)
        XCTAssertEqual(authService.loginCallCount, 0)
        XCTAssertEqual(authService.logoutCallCount, 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (RegisterViewModel, AuthServiceStub) {
        let emailValidator = EmailValidator()
        let passwordValidator = PasswordValidator()
        let authService = AuthServiceStub()
        let sut = RegisterViewModel(
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
