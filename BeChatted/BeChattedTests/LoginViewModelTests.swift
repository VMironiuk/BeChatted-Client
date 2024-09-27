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
  
  func test_login_doesNotSendUserByEmailMessageWhenLoginFails() {
    let (sut, authService, userService) = makeSUT()
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
    
    XCTAssertEqual(userService.userByEmailCallCount, 0)
  }
  
  func test_login_sendsUserByEmailMessageWhenLoginSucceeds() {
    let (sut, authService, userService) = makeSUT()
    let exp = expectation(description: "Wait for login request completion")
    let sub = sut.$state.sink { result in
      if result == .fetchingUser {
        exp.fulfill()
      }
    }
    
    sut.login()
    authService.completeLoginSuccessfully()
    
    wait(for: [exp], timeout: 1)
    sub.cancel()
    
    XCTAssertEqual(userService.userByEmailCallCount, 1)
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
  
  func test_login_failsIfUserByEmailRequestFails() {
    let (sut, authService, userService) = makeSUT()
    let expLogin = expectation(description: "Wait for login request completion")
    let expFetchUser = expectation(description: "Wait for fetch user request completion")
    let sub = sut.$state.sink { result in
      if result == .fetchingUser {
        expLogin.fulfill()
      }
      if result == .failure(.fetchUser) {
        expFetchUser.fulfill()
      }
    }
    
    sut.login()
    authService.completeLoginSuccessfully()
    
    wait(for: [expLogin], timeout: 1)
    
    userService.complete(with: .connectivity)
    
    wait(for: [expFetchUser], timeout: 1)
    sub.cancel()
  }
  
  func test_login_succeedsIfLoginAndUserByEmailRequestsSucceed() {
    let (sut, authService, userService) = makeSUT()
    let expLogin = expectation(description: "Wait for login request completion")
    let expFetchUser = expectation(description: "Wait for fetch user request completion")
    let anyUserInfo = UserInfo(id: "id", name: "name", email: "email")
    let sub = sut.$state.sink { result in
      if result == .fetchingUser {
        expLogin.fulfill()
      }
      if result == .success {
        expFetchUser.fulfill()
      }
    }
    
    sut.login()
    authService.completeLoginSuccessfully()
    
    wait(for: [expLogin], timeout: 1)
    
    userService.complete(with: anyUserInfo)
    
    wait(for: [expFetchUser], timeout: 1)
    sub.cancel()
  }
  
  func test_login_receivesUserInfoOnSuccess() {
    let expectedUserInfo = UserInfo(id: "id", name: "name", email: "email")
    let (sut, authService, userService) = makeSUT { _, receivedUserInfo in
      XCTAssertEqual(expectedUserInfo, receivedUserInfo)
    }
    let expLogin = expectation(description: "Wait for login request completion")
    let expFetchUser = expectation(description: "Wait for fetch user request completion")
    let sub = sut.$state.sink { result in
      if result == .fetchingUser {
        expLogin.fulfill()
      }
      if result == .success {
        expFetchUser.fulfill()
      }
    }
    
    sut.login()
    authService.completeLoginSuccessfully()
    
    wait(for: [expLogin], timeout: 1)
    
    userService.complete(with: expectedUserInfo)
    
    wait(for: [expFetchUser], timeout: 1)
    sub.cancel()
  }
  
  // MARK: - Helpers
  
  private func makeSUT(
    onLoginSuccessAction: @escaping (String, UserInfo) -> Void = { _, _ in },
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
      onLoginSuccessAction: onLoginSuccessAction
    )
    
    trackForMemoryLeaks(sut, file: file, line: line)
    trackForMemoryLeaks(authService, file: file, line: line)
    trackForMemoryLeaks(userService, file: file, line: line)
    
    return (sut, authService, userService)
  }
}

extension UserInfo: @retroactive Equatable {
  public static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
    lhs.id == rhs.id && lhs.name == rhs.name && lhs.email == rhs.email
  }
}
