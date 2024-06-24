//
//  RegisterViewModelTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import XCTest
import BeChatted

final class RegisterViewModelTests: XCTestCase {

    func test_init_containsNonValidUserInput() {
        let (sut, _) = makeSUT(userName: "", isEmailValidStub: false, isPasswordValidStub: false)
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnEmptyName() {
        let (sut, _) = makeSUT(userName: "", isEmailValidStub: true, isPasswordValidStub: true)
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidEmail() {
        let (sut, _) = makeSUT(userName: "Johny B", isEmailValidStub: false, isPasswordValidStub: true)
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsFalseOnInvalidPassword() {
        let (sut, _) = makeSUT(userName: "Johny B", isEmailValidStub: true, isPasswordValidStub: false)
        XCTAssertFalse(sut.isUserInputValid)
    }
    
    func test_isUserInputValid_returnsTrueOnValidCredentials() {
        let (sut, _) = makeSUT(userName: "Johny B", isEmailValidStub: true, isPasswordValidStub: true)
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
            toCompleteWithState: .failure(unknownCreateAccountError),
            expectedCreateAccountCallCount: 1,
            expectedAddUserCallCount: 0,
            expectedLoginCallCount: 0,
            expectedLogoutCallCount: 0,
            when: {
                authService.completeCreateAccountWithError(.unknown)
            }
        )
        
        let exp = expectation(description: "Wait for moving state back to idle")
        let sub = sut.$state.sink { result in
            if result == .idle {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1)
        sub.cancel()
    }
    
    func test_register_failsIfAuthServiceLoginRequestFails() {
        let (sut, authService) = makeSUT()
        let unknownLoginError = unknownRegisterError()
        
        expect(
            sut,
            authService: authService,
            toCompleteWithState: .failure(unknownLoginError),
            expectedCreateAccountCallCount: 1,
            expectedAddUserCallCount: 0,
            expectedLoginCallCount: 1,
            expectedLogoutCallCount: 0,
            when: {
                authService.completeCreateAccountSuccessfully()
                authService.completeLoginWithError(.unknown)
            }
        )
        
        let exp = expectation(description: "Wait for moving state back to idle")
        let sub = sut.$state.sink { result in
            if result == .idle {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1)
        sub.cancel()
    }

    func test_register_failsIfAuthServiceAddUserRequestFails() {
        let (sut, authService) = makeSUT()
        let unknownAddUserError = unknownRegisterError()
        
        expect(
            sut,
            authService: authService,
            toCompleteWithState: .failure(unknownAddUserError),
            expectedCreateAccountCallCount: 1,
            expectedAddUserCallCount: 1,
            expectedLoginCallCount: 1,
            expectedLogoutCallCount: 0,
            when: {
                authService.completeCreateAccountSuccessfully()
                authService.completeLoginSuccessfully()
                authService.completeAddUserWithError(.unknown)
            }
        )
        
        let exp = expectation(description: "Wait for moving state back to idle")
        let sub = sut.$state.sink { result in
            if result == .idle {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1)
        sub.cancel()
    }

    func test_register_succeedsIfAllAuthServiceRequestsSucceed() {
        let (sut, authService) = makeSUT()
        
        expect(
            sut,
            authService: authService,
            toCompleteWithState: .success,
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
        userName: String = "",
        isEmailValidStub: Bool = false,
        isPasswordValidStub: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (RegisterViewModel, AuthServiceStub) {
        let emailValidator = EmailValidatorStub(isValidStubbed: isEmailValidStub)
        let passwordValidator = PasswordValidatorStub(isValidStubbed: isPasswordValidStub)
        let authService = AuthServiceStub()
        let sut = RegisterViewModel(
            emailValidator: emailValidator,
            passwordValidator: passwordValidator,
            authService: authService
        )
        
        sut.name = userName
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, authService)
    }

    private func expect(
        _ sut: RegisterViewModel,
        authService: AuthServiceStub,
        toCompleteWithState expectedState: RegisterViewModel.State,
        expectedCreateAccountCallCount: Int,
        expectedAddUserCallCount: Int,
        expectedLoginCallCount: Int,
        expectedLogoutCallCount: Int,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for registration completion")
        let sub = sut.$state.sink { result in
            if result == expectedState {
                exp.fulfill()
            }
        }

        sut.register()
        action()
        
        wait(for: [exp], timeout: 1.0)
        sub.cancel()
        
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
        .unknown
    }
}
