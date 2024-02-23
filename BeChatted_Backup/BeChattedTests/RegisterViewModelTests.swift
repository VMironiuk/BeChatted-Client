//
//  RegisterViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import XCTest
import BeChatted
import BeChattedAuth
import BeChattedUserInputValidation

final class RegisterViewModelTests: XCTestCase {

    func test_init_containsNonValidUserInput() {
        let (sut, _) = makeSUT()
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_init_setsSuccessTitleCorrectly() {
        let successTitle = "success title"
        let successMessage = SuccessMessageStub(stubbedTitle: successTitle)
        let (sut, _) = makeSUT(successMessage: successMessage)
        
        XCTAssertEqual(sut.successMessageTitle, successTitle)
    }
    
    func test_init_setsSuccessDescriptionCorrectly() {
        let successDescription = "success description"
        let successMessage = SuccessMessageStub(stubbedDescription: successDescription)
        let (sut, _) = makeSUT(successMessage: successMessage)
        
        XCTAssertEqual(sut.successMessageDescription, successDescription)
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
        let unknownCreateAccountError = unknownRegisterError()
        
        expect(
            sut,
            authService: authService,
            toCompleteWith: unknownCreateAccountError,
            expectedCreateAccountCallCount: 1,
            expectedAddUserCallCount: 0,
            expectedLoginCallCount: 0,
            expectedLogoutCallCount: 0,
            when: {
                authService.completeCreateAccount(with: .unknown)
            }
        )
    }
    
    func test_register_failsIfAuthServiceLoginRequestFails() {
        let (sut, authService) = makeSUT()
        let unknownLoginError = unknownRegisterError()
        
        expect(
            sut,
            authService: authService,
            toCompleteWith: unknownLoginError,
            expectedCreateAccountCallCount: 1,
            expectedAddUserCallCount: 0,
            expectedLoginCallCount: 1,
            expectedLogoutCallCount: 0,
            when: {
                authService.completeCreateAccountSuccessfully()
                authService.completeLogin(with: .unknown)
            }
        )
    }

    func test_register_failsIfAuthServiceAddUserRequestFails() {
        let (sut, authService) = makeSUT()
        let unknownAddUserError = unknownRegisterError()
        
        expect(
            sut,
            authService: authService,
            toCompleteWith: unknownAddUserError,
            expectedCreateAccountCallCount: 1,
            expectedAddUserCallCount: 1,
            expectedLoginCallCount: 1,
            expectedLogoutCallCount: 0,
            when: {
                authService.completeCreateAccountSuccessfully()
                authService.completeLoginSuccessfully()
                authService.completeAddUser(with: .unknown)
            }
        )
    }

    func test_register_succeedsIfAllAuthServiceRequestsSucceed() {
        let (sut, authService) = makeSUT()
        let noError: NSError? = nil
        
        expect(
            sut,
            authService: authService,
            toCompleteWith: noError,
            expectedCreateAccountCallCount: 1,
            expectedAddUserCallCount: 1,
            expectedLoginCallCount: 1,
            expectedLogoutCallCount: 0,
            when: {
                authService.completeCreateAccountSuccessfully()
                authService.completeLoginSuccessfully()
                authService.completeAddUserSuccessfully()
            }
        )
    }

    // MARK: - Helpers
    
    private func makeSUT(
        successMessage: SuccessMessageStub = SuccessMessageStub(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (RegisterViewModel, AuthServiceStub) {
        let emailValidator = EmailValidator()
        let passwordValidator = PasswordValidator()
        let authService = AuthServiceStub()
        let sut = RegisterViewModel(
            emailValidator: emailValidator,
            passwordValidator: passwordValidator,
            authService: authService,
            successMessage: successMessage
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, authService)
    }
    
    private func expect(
        _ sut: RegisterViewModel,
        authService: AuthServiceStub,
        toCompleteWith expectedError: NSError?,
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
                break
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
    
    private func expect(
        _ sut: RegisterViewModel,
        authService: AuthServiceStub,
        toCompleteWith expectedError: AuthError?,
        expectedCreateAccountCallCount: Int,
        expectedAddUserCallCount: Int,
        expectedLoginCallCount: Int,
        expectedLogoutCallCount: Int,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for registration completion")
        var receivedError: AuthError?
        sut.register { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                receivedError = error
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
        
    private func unknownRegisterError() -> AuthError {
        AuthError(authServiceError: .unknown)
    }
    
    private struct SuccessMessageStub: MessageProtocol {
        var stubbedTitle: String = ""
        var stubbedDescription: String = ""
        
        var title: String { stubbedTitle }
        var description: String { stubbedDescription }
    }
}