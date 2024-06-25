//
//  AuthServiceStub.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 24.11.2023.
//

import Foundation
import BeChatted

final class AuthServiceStub: AuthServiceProtocol {
  private(set) var createAccountCallCount: Int = 0
  private(set) var addUserCallCount: Int = 0
  private(set) var loginCallCount: Int = 0
  private(set) var logoutCallCount: Int = 0
  
  private var createAccountCompletion: ((Result<Void, AuthError>) -> Void)?
  private var loginCompletion: ((Result<LoginInfo, AuthError>) -> Void)?
  private var addUserCompletion: ((Result<AddedUserInfo, AuthError>) -> Void)?
  
  func createAccount(
    _ payload: CreateAccountPayload,
    completion: @escaping (Result<Void, AuthError>) -> Void
  ) {
    createAccountCallCount += 1
    createAccountCompletion = completion
  }
  
  func addUser(
    _ payload: AddUserPayload,
    authToken: String,
    completion: @escaping (Result<AddedUserInfo, AuthError>) -> Void
  ) {
    addUserCallCount += 1
    addUserCompletion = completion
  }
  
  func login(
    _ payload: LoginPayload,
    completion: @escaping (Result<LoginInfo, AuthError>) -> Void
  ) {
    loginCallCount += 1
    loginCompletion = completion
  }
  
  func logout(completion: @escaping (Result<Void, AuthError>) -> Void) {
    logoutCallCount += 1
  }
  
  func completeCreateAccountWithError(_ error: AuthError) {
    createAccountCompletion?(.failure(error))
  }
  
  func completeCreateAccountSuccessfully() {
    createAccountCompletion?(.success(()))
  }
  
  func completeLoginWithError(_ error: AuthError) {
    loginCompletion?(.failure(error))
  }
  
  func completeLoginSuccessfully() {
    let dummyLoginInfoData = """
        {
            "user": "a user",
            "token": "auth token"
        }
        """.data(using: .utf8)
    let dummyLoginInfo = try! JSONDecoder().decode(LoginInfo.self, from: dummyLoginInfoData!)
    loginCompletion?(.success(dummyLoginInfo))
  }
  
  func completeAddUserWithError(_ error: AuthError) {
    addUserCompletion?(.failure(error))
  }
  
  func completeAddUserSuccessfully() {
    let dummyNewUserInfoData = """
        {
            "name": "new user",
            "email": "new-user@example.com",
            "avatarName": "avatarName",
            "avatarColor": "avatarColor"
        }
        """.data(using: .utf8)
    let dummyNewUserInfo = try! JSONDecoder().decode(AddedUserInfo.self, from: dummyNewUserInfoData!)
    addUserCompletion?(.success(dummyNewUserInfo))
  }
}
