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
        
        expect(
            sut,
            authService: authService,
            toCompleteWith: createAccountError,
            expectedCreateAccountCallCount: 1,
            expectedAddUserCallCount: 0,
            expectedLoginCallCount: 0,
            expectedLogoutCallCount: 0,
            when: {
                authService.completeCreateAccount(with: createAccountError)
            }
        )
    }
    
    func test_register_failsIfAuthServiceLoginRequestFails() {
        let (sut, authService) = makeSUT()
        let loginError: NSError = anyNSError()
        
        expect(
            sut,
            authService: authService,
            toCompleteWith: loginError,
            expectedCreateAccountCallCount: 1,
            expectedAddUserCallCount: 0,
            expectedLoginCallCount: 1,
            expectedLogoutCallCount: 0,
            when: {
                authService.completeCreateAccountSuccessfully()
                authService.completeLogin(with: loginError)
            }
        )
    }

    func test_register_failsIfAuthServiceAddUserRequestFails() {
        let (sut, authService) = makeSUT()
        let addUserError: NSError = anyNSError()
        
        expect(
            sut,
            authService: authService,
            toCompleteWith: addUserError,
            expectedCreateAccountCallCount: 1,
            expectedAddUserCallCount: 1,
            expectedLoginCallCount: 1,
            expectedLogoutCallCount: 0,
            when: {
                authService.completeCreateAccountSuccessfully()
                authService.completeLoginSuccessfully()
                authService.completeAddUser(with: addUserError)
            }
        )
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
    
    private func expect(
        _ sut: RegisterViewModel,
        authService: AuthServiceStub,
        toCompleteWith expectedError: NSError,
        expectedCreateAccountCallCount: Int,
        expectedAddUserCallCount: Int,
        expectedLoginCallCount: Int,
        expectedLogoutCallCount: Int,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for registration completion")
        var receivedError: NSError?
        sut.register { result in
            switch result {
            case .success:
                XCTFail("Expected registration to fail, got \(result) instead", file: file, line: line)
            case .failure(let error):
                receivedError = error as NSError
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        XCTAssertEqual(
            authService.createAccountCallCount,
            expectedCreateAccountCallCount,
            "Expected \(expectedCreateAccountCallCount) create account calls count, got \(authService.createAccountCallCount) instead",
            file: file,
            line: line
        )
        XCTAssertEqual(
            authService.addUserCallCount,
            expectedAddUserCallCount,
            "Expected \(expectedAddUserCallCount) add user calls count, got \(authService.addUserCallCount) instead",
            file: file,
            line: line
        )
        XCTAssertEqual(
            authService.loginCallCount,
            expectedLoginCallCount,
            "Expected \(expectedLoginCallCount) login calls count, got \(authService.loginCallCount) instead",
            file: file,
            line: line
        )
        XCTAssertEqual(
            authService.logoutCallCount,
            expectedLogoutCallCount,
            "Expected \(expectedLogoutCallCount) logout calls count, got \(authService.logoutCallCount) instead",
            file: file,
            line: line
        )
    }
    
    func anyNSError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
}
