//
//  AuthServiceStub.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 24.11.2023.
//

import Foundation
import BeChattedAuth

final class AuthServiceStub: AuthServiceProtocol {
    private(set) var createAccountCallCount: Int = 0
    private(set) var addUserCallCount: Int = 0
    private(set) var loginCallCount: Int = 0
    private(set) var logoutCallCount: Int = 0
    
    private var createAccountCompletion: ((Result<Void, AuthServiceError>) -> Void)?
    private var loginCompletion: ((Result<UserLoginInfo, AuthServiceError>) -> Void)?
    private var addUserCompletion: ((Result<NewUserInfo, AuthServiceError>) -> Void)?
    
    func createAccount(
        _ payload: NewAccountPayload,
        completion: @escaping (Result<Void, AuthServiceError>) -> Void
    ) {
        createAccountCallCount += 1
        createAccountCompletion = completion
    }
    
    func addUser(
        _ payload: NewUserPayload,
        authToken: String,
        completion: @escaping (Result<NewUserInfo, AuthServiceError>) -> Void
    ) {
        addUserCallCount += 1
        addUserCompletion = completion
    }
    
    func login(
        _ payload: UserLoginPayload,
        completion: @escaping (Result<UserLoginInfo, AuthServiceError>) -> Void
    ) {
        loginCallCount += 1
        loginCompletion = completion
    }
    
    func logout(completion: @escaping (Result<Void, AuthServiceError>) -> Void) {
        logoutCallCount += 1
    }
    
    func completeCreateAccount(with error: AuthServiceError) {
        createAccountCompletion?(.failure(error))
    }
    
    func completeCreateAccountSuccessfully() {
        createAccountCompletion?(.success(()))
    }
    
    func completeLogin(with error: AuthServiceError) {
        loginCompletion?(.failure(error))
    }
    
    func completeLoginSuccessfully() {
        let dummyLoginInfoData = """
        {
            "user": "a user",
            "token": "auth token"
        }
        """.data(using: .utf8)
        let dummyUserLoginInfo = try! JSONDecoder().decode(UserLoginInfo.self, from: dummyLoginInfoData!)
        loginCompletion?(.success(dummyUserLoginInfo))
    }
    
    func completeAddUser(with error: AuthServiceError) {
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
        let dummyNewUserInfo = try! JSONDecoder().decode(NewUserInfo.self, from: dummyNewUserInfoData!)
        addUserCompletion?(.success(dummyNewUserInfo))
    }
}
