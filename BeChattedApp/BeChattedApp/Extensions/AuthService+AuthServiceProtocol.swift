//
//  AuthService+AuthServiceProtocol.swift
//  BeChattedApp
//
//  Created by Volodymyr Myroniuk on 27.02.2024.
//

import Foundation
import BeChattedAuth
import BeChattediOS

extension AuthService: BeChattediOS.AuthServiceProtocol {
    public func createAccount(
        _ payload: BeChattediOS.CreateAccountPayload,
        completion: @escaping (Result<Void, BeChattediOS.AuthError>) -> Void
    ) {
        createAccount(payload.mapped) { completion($0.mapped) }
    }

    public func login(
        _ payload: BeChattediOS.LoginPayload,
        completion: @escaping (Result<BeChattediOS.LoginInfo, BeChattediOS.AuthError>) -> Void
    ) {
        login(payload.mapped) { completion($0.mapped) }
    }

    public func addUser(
        _ payload: BeChattediOS.AddUserPayload,
        authToken: String,
        completion: @escaping (Result<BeChattediOS.AddedUserInfo, BeChattediOS.AuthError>) -> Void
    ) {
        addUser(payload.mapped, authToken: authToken) { completion($0.mapped) }
    }
}

extension Result<Void, AuthServiceError> {
    var mapped: Result<Void, AuthError> {
        switch self {
        case .success: return .success(())
        case .failure(let error): return .failure(error.mapped)
        }
    }
}

extension Result<UserLoginInfo, AuthServiceError> {
    var mapped: Result<LoginInfo, AuthError> {
        switch self {
        case .success(let info): return .success(info.mapped)
        case .failure(let error): return .failure(error.mapped)
        }
    }
}

extension Result<NewUserInfo, AuthServiceError> {
    var mapped: Result<AddedUserInfo, AuthError> {
        switch self {
        case .success(let info): return .success(info.mapped)
        case .failure(let error): return .failure(error.mapped)
        }
    }
}

extension AuthServiceError {
    var mapped: BeChattediOS.AuthError {
        switch self {
        case .connectivity: return .connectivity
        case .credentials: return .credentials
        case .email: return .email
        case .server: return .server
        case .unknown: return .unknown
        }
    }
}

extension CreateAccountPayload {
    var mapped: NewAccountPayload {
        NewAccountPayload(email: email, password: password)
    }
}


extension LoginPayload {
    var mapped: UserLoginPayload {
        UserLoginPayload(email: email, password: password)
    }
}

extension UserLoginInfo {
    var mapped: LoginInfo {
        LoginInfo(user: user, token: token)
    }
}

extension AddUserPayload {
    var mapped: NewUserPayload {
        NewUserPayload(name: name, email: email, avatarName: avatarName, avatarColor: avatarColor)
    }
}

extension NewUserInfo {
    var mapped: AddedUserInfo {
        AddedUserInfo(name: name, email: email, avatarName: avatarName, avatarColor: avatarColor)
    }
}
