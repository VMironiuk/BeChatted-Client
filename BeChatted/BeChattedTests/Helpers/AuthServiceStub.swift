//
//  AuthServiceStub.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 24.11.2023.
//

import Foundation
import BeChattedAuth

final class AuthServiceStub: AuthServiceProtocol {
    func createAccount(
        _ payload: NewAccountPayload,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {}
    
    func addUser(
        _ payload: NewUserPayload,
        completion: @escaping (Result<NewUserInfo, Error>) -> Void
    ) {}
    
    func login(
        _ payload: UserLoginPayload,
        completion: @escaping (Result<UserLoginInfo, Error>) -> Void
    ) {}
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {}
}
