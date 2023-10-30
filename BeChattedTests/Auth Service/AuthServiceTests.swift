//
//  AuthServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 30.10.2023.
//

import XCTest
import BeChatted

final class AuthService {
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
}

final class AuthServiceTests: XCTestCase {
    
    func test_init_doesNotSendAnyMessages() {
        // given
        let newAccountService = NewAccountServiceSpy()
        let addNewUserService = AddNewUserServiceSpy()
        let userLoginService = UserLoginServiceSpy()
        let userLogoutService = UserLogoutServiceSpy()
        
        // when
        _ = AuthService(
            newAccountService: newAccountService,
            addNewUserService: addNewUserService,
            userLoginService: userLoginService,
            userLogoutService: userLogoutService
        )
        
        // then
        XCTAssertTrue(newAccountService.messages.isEmpty)
        XCTAssertTrue(addNewUserService.messages.isEmpty)
        XCTAssertTrue(userLoginService.messages.isEmpty)
        XCTAssertTrue(userLogoutService.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private final class NewAccountServiceSpy: NewAccountServiceProtocol {
        private(set) var messages = [Message]()
        
        struct Message {
            private let newAccountPayload: NewAccountPayload
            private let completion: (Result<Void, Error>) -> Void
        }
        
        func send(
            newAccountPayload: NewAccountPayload,
            completion: @escaping (Result<Void, Error>) -> Void
        ) {
        }
    }
    
    private final class AddNewUserServiceSpy: AddNewUserServiceProtocol {
        private(set) var messages = [Message]()
        
        struct Message {
            private let newUserPayload: NewUserPayload
            private let completion: (Result<NewUserInfo, Error>) -> Void
        }
        
        func send(
            newUserPayload: NewUserPayload,
            completion: @escaping (Result<NewUserInfo, Error>) -> Void
        ) {
        }
    }
    
    private final class UserLoginServiceSpy: UserLoginServiceProtocol {
        private(set) var messages = [Message]()
        
        struct Message {
            private let userLoginPayload: UserLoginPayload
            private let completion: (Result<UserLoginInfo, Error>) -> Void
        }

        func send(
            userLoginPayload: UserLoginPayload,
            completion: @escaping (Result<UserLoginInfo, Error>) -> Void
        ) {
        }
    }
    
    private final class UserLogoutServiceSpy: UserLogoutServiceProtocol {
        private(set) var messages = [Message]()
        
        struct Message {
            private let completion: (Result<Void, Error>) -> Void
        }

        func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        }
    }
}
