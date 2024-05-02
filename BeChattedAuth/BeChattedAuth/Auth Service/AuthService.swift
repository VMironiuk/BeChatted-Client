//
//  AuthService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.10.2023.
//

import Foundation

public enum AuthServiceError: Error {
    case server
    case connectivity
    case email
    case credentials
    case unknown
}

public struct AuthServiceConfiguration {
    let newAccountURL: URL
    let newUserURL: URL
    let userLoginURL: URL
    let userLogoutURL: URL
    let httpClient: HTTPClientProtocol
    
    public init(newAccountURL: URL, newUserURL: URL, userLoginURL: URL, userLogoutURL: URL, httpClient: HTTPClientProtocol) {
        self.newAccountURL = newAccountURL
        self.newUserURL = newUserURL
        self.userLoginURL = userLoginURL
        self.userLogoutURL = userLogoutURL
        self.httpClient = httpClient
    }
}

public final class AuthService {
    private let newAccountService: NewAccountServiceProtocol
    private let addNewUserService: AddNewUserServiceProtocol
    private let userLoginService: UserLoginServiceProtocol
    private let userLogoutService: UserLogoutServiceProtocol
    
    init(
        newAccountService: NewAccountServiceProtocol,
        addNewUserService: AddNewUserServiceProtocol,
        userLoginService: UserLoginServiceProtocol,
        userLogoutService: UserLogoutServiceProtocol
    ) {
        self.newAccountService = newAccountService
        self.addNewUserService = addNewUserService
        self.userLoginService = userLoginService
        self.userLogoutService = userLogoutService
    }
    
    public init(configuration: AuthServiceConfiguration) {
        newAccountService = NewAccountService(url: configuration.newAccountURL, client: configuration.httpClient)
        addNewUserService = AddNewUserService(url: configuration.newUserURL, client: configuration.httpClient)
        userLoginService = UserLoginService(url: configuration.userLoginURL, client: configuration.httpClient)
        userLogoutService = UserLogoutService(url: configuration.userLogoutURL, client: configuration.httpClient)
    }
    
    public func createAccount(_ payload: NewAccountPayload, completion: @escaping (Result<Void, AuthServiceError>) -> Void) {
        newAccountService.send(newAccountPayload: payload) { result in
            completion(NewAccountResultMapper.result(for: result))
        }
    }
    
    public func addUser(_ payload: NewUserPayload, authToken: String, completion: @escaping (Result<NewUserInfo, AuthServiceError>) -> Void) {
        addNewUserService.send(newUserPayload: payload, authToken: authToken) { result in
            completion(AddUserResultMapper.result(for: result))
        }
    }
    
    public func login(_ payload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, AuthServiceError>) -> Void) {
        userLoginService.send(userLoginPayload: payload) { result in
            completion(LoginResultMapper.result(for: result))
        }
    }
        
    public func logout(completion: @escaping (Result<Void, AuthServiceError>) -> Void) {
        userLogoutService.logout { result in
            completion(LogoutResultMapper.result(for: result))
        }
    }
}
