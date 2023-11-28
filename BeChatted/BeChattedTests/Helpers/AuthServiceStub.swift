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
    
    private var createAccountCompletion: ((Result<Void, Error>) -> Void)?
    private var loginCompletion: ((Result<UserLoginInfo, Error>) -> Void)?
    private var addUserCompletion: ((Result<NewUserInfo, Error>) -> Void)?
    
    func createAccount(
        _ payload: NewAccountPayload,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        createAccountCallCount += 1
        createAccountCompletion = completion
    }
    
    func addUser(
        _ payload: NewUserPayload,
        completion: @escaping (Result<NewUserInfo, Error>) -> Void
    ) {
        addUserCallCount += 1
        addUserCompletion = completion
    }
    
    func login(
        _ payload: UserLoginPayload,
        completion: @escaping (Result<UserLoginInfo, Error>) -> Void
    ) {
        loginCallCount += 1
        loginCompletion = completion
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        logoutCallCount += 1
    }
    
    func completeCreateAccount(with error: Error) {
        createAccountCompletion?(.failure(error))
    }
    
    func completeCreateAccountSuccessfully() {
        createAccountCompletion?(.success(()))
    }
    
    func completeLogin(with error: Error) {
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
    
    func completeAddUser(with error: Error) {
        addUserCompletion?(.failure(error))
    }
}
