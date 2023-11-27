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
    }
    
    func login(
        _ payload: UserLoginPayload,
        completion: @escaping (Result<UserLoginInfo, Error>) -> Void
    ) {
        loginCallCount += 1
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        logoutCallCount += 1
    }
    
    func completeCreateAccount(with error: Error) {
        createAccountCompletion?(.failure(error))
    }
}
