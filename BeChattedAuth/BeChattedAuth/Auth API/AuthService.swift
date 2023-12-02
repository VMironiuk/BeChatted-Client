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
            completion(NewAccountResultMapper.result(for: result))
        }
    }
    
    func addUser(_ payload: NewUserPayload, authToken: String, completion: @escaping (Result<NewUserInfo, AuthServiceError>) -> Void) {
        addNewUserService.send(newUserPayload: payload, authToken: authToken) { result in
            completion(AddUserResultMapper.result(for: result))
        }
    }
    
    func login(_ payload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, AuthServiceError>) -> Void) {
        userLoginService.send(userLoginPayload: payload) { result in
            completion(LoginResultMapper.result(for: result))
        }
    }
        
    func logout(completion: @escaping (Result<Void, AuthServiceError>) -> Void) {
        userLogoutService.logout { result in
            completion(LogoutResultMapper.result(for: result))
        }
    }
}
