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
    let (sut, _, _) = makeSUT(isEmailValidStub: false, isPasswordValidStub: false)
    XCTAssertFalse(sut.isUserInputValid)
  }
  
  func test_isUserInputValid_returnsFalseOnInvalidPassword() {
    let (sut, _, _) = makeSUT(isEmailValidStub: true, isPasswordValidStub: false)
    XCTAssertFalse(sut.isUserInputValid)
  }
  
  func test_isUserInputValid_returnsFalseOnInvalidEmail() {
    let (sut, _, _) = makeSUT(isEmailValidStub: false, isPasswordValidStub: true)
    XCTAssertFalse(sut.isUserInputValid)
  }
  
  func test_isUserInputValid_returnsTrueOnValidCredentials() {
    let (sut, _, _) = makeSUT(isEmailValidStub: true, isPasswordValidStub: true)
    XCTAssertTrue(sut.isUserInputValid)
  }
  
  func tests_init_doesNotSendMessagesToServices() {
    let (_, authService, userService) = makeSUT()
    
    XCTAssertEqual(authService.createAccountCallCount, 0)
    XCTAssertEqual(authService.addUserCallCount, 0)
    XCTAssertEqual(authService.loginCallCount, 0)
    XCTAssertEqual(authService.logoutCallCount, 0)
    
    XCTAssertEqual(userService.userByEmailCallCount, 0)
  }
  
  func test_login_sendsOnlyOneLoginMessageToAuthServiceOnOneCall() {
    let (sut, authService, _) = makeSUT()
    
    sut.login()
    
    XCTAssertEqual(authService.createAccountCallCount, 0)
    XCTAssertEqual(authService.addUserCallCount, 0)
    XCTAssertEqual(authService.loginCallCount, 1)
    XCTAssertEqual(authService.logoutCallCount, 0)
  }
  
  func test_login_sendsOnlyTwoLoginMessagesToAuthServiceOnTwoCalls() {
    let (sut, authService, _) = makeSUT()
    
    sut.login()
    sut.login()
    
    XCTAssertEqual(authService.createAccountCallCount, 0)
    XCTAssertEqual(authService.addUserCallCount, 0)
    XCTAssertEqual(authService.loginCallCount, 2)
    XCTAssertEqual(authService.logoutCallCount, 0)
  }
  
  func test_login_failsIfAuthServiceLoginRequestFails() {
    let (sut, authService, _) = makeSUT()
    let exp = expectation(description: "Wait for login request completion")
    let sub = sut.$state.sink { result in
      if result == .failure(AuthError.unknown) {
        exp.fulfill()
      }
    }
    
    sut.login()
    authService.completeLoginWithError(.unknown)
    
    wait(for: [exp], timeout: 1)
    sub.cancel()
  }
  
  func test_login_succeedsIfAuthServiceLoginRequestSucceeds() {
    let (sut, authService, _) = makeSUT()
    let exp = expectation(description: "Wait for login request completion")
    let sub = sut.$state.sink { result in
      if result != .inProgress {
        exp.fulfill()
      }
    }
    
    sut.login()
    authService.completeLoginSuccessfully()
    
    wait(for: [exp], timeout: 1)
    sub.cancel()
  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    isEmailValidStub: Bool = false,
    isPasswordValidStub: Bool = false,
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> (LoginViewModel, AuthServiceStub, UserServiceStub) {
    let emailValidator = EmailValidatorStub(isValidStubbed: isEmailValidStub)
    let passwordValidator = PasswordValidatorStub(isValidStubbed: isPasswordValidStub)
    let authService = AuthServiceStub()
    let userService = UserServiceStub()
    let sut = LoginViewModel(
      emailValidator: emailValidator,
      passwordValidator: passwordValidator,
      authService: authService,
      userService: userService,
      onLoginSuccessAction: { _ in }
    )
    
    trackForMemoryLeaks(sut, file: file, line: line)
    trackForMemoryLeaks(authService, file: file, line: line)
    trackForMemoryLeaks(userService, file: file, line: line)
    
    return (sut, authService, userService)
  }
}
