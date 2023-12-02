//
//  AuthService.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.10.2023.
//

import Foundation

final class AuthService: AuthServiceProtocol {
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
    
    func createAccount(_ payload: NewAccountPayload, completion: @escaping (Result<Void, AuthServiceError>) -> Void) {
        newAccountService.send(newAccountPayload: payload) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                switch error {
                case .server:
                    completion(.failure(.server))
                case .connectivity:
                    completion(.failure(.connectivity))
                case .email:
                    completion(.failure(.email))
                case .unknown:
                    completion(.failure(.unknown))
                }
            }
        }
    }
    
    func addUser(_ payload: NewUserPayload, authToken: String, completion: @escaping (Result<NewUserInfo, AuthServiceError>) -> Void) {
        addNewUserService.send(newUserPayload: payload, authToken: authToken) { result in
            switch result {
            case .success(let newUserInfo):
                completion(.success(newUserInfo))
            case .failure(let error):
                switch error {
                case .server:
                    completion(.failure(.server))
                case .connectivity:
                    completion(.failure(.connectivity))
                case .invalidData, .unknown:
                    completion(.failure(.unknown))
                }
            }
        }
    }
    
    func login(_ payload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, AuthServiceError>) -> Void) {
        userLoginService.send(userLoginPayload: payload) { result in
            switch result {
            case .success(let userLoginInfo):
                completion(.success(userLoginInfo))
            case .failure(let error):
                switch error {
                case .server:
                    completion(.failure(.server))
                case .connectivity:
                    completion(.failure(.connectivity))
                case .credentials:
                    completion(.failure(.credentials))
                case .invalidData, .unknown:
                    completion(.failure(.unknown))
                }
            }
        }
    }
        
    func logout(completion: @escaping (Result<Void, AuthServiceError>) -> Void) {
        userLogoutService.logout { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                switch error {
                case .connectivity:
                    completion(.failure(.connectivity))
                }
            }
        }
    }
}
