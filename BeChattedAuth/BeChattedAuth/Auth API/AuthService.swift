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
    
    func send(newAccountPayload: NewAccountPayload, completion: @escaping (Result<Void, Error>) -> Void) {
        newAccountService.send(newAccountPayload: newAccountPayload, completion: completion)
    }
    
    func send(userLoginPayload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, Error>) -> Void) {
        userLoginService.send(userLoginPayload: userLoginPayload, completion: completion)
    }
    
    func send(newUserPayload: NewUserPayload, completion: @escaping (Result<NewUserInfo, Error>) -> Void) {
        addNewUserService.send(newUserPayload: newUserPayload, completion: completion)
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        userLogoutService.logout(completion: completion)
    }
}
