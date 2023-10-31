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
    
    func test_sendNewAccount_sendsNewAccountMessage() {
        // given
        let newAccountService = NewAccountServiceSpy()
        let addNewUserService = AddNewUserServiceSpy()
        let userLoginService = UserLoginServiceSpy()
        let userLogoutService = UserLogoutServiceSpy()
        
        let newAccountPayload = anyNewAccountPayload()
        
        let sut = AuthService(
            newAccountService: newAccountService,
            addNewUserService: addNewUserService,
            userLoginService: userLoginService,
            userLogoutService: userLogoutService
        )
        
        // when
        sut.send(newAccountPayload: newAccountPayload) { _ in }
        
        // then
        XCTAssertEqual(newAccountService.messages[0].newAccountPayload, newAccountPayload)
        XCTAssertTrue(addNewUserService.messages.isEmpty)
        XCTAssertTrue(userLoginService.messages.isEmpty)
        XCTAssertTrue(userLogoutService.messages.isEmpty)
    }
    
    func test_sendUserLogin_sendsUserLoginMessage() {
        // given
        let newAccountService = NewAccountServiceSpy()
        let addNewUserService = AddNewUserServiceSpy()
        let userLoginService = UserLoginServiceSpy()
        let userLogoutService = UserLogoutServiceSpy()
        
        let userLoginPayload = anyUserLoginPayload()
        
        let sut = AuthService(
            newAccountService: newAccountService,
            addNewUserService: addNewUserService,
            userLoginService: userLoginService,
            userLogoutService: userLogoutService
        )
        
        // when
        sut.send(userLoginPayload: userLoginPayload) { _ in }
        
        // then
        XCTAssertTrue(newAccountService.messages.isEmpty)
        XCTAssertTrue(addNewUserService.messages.isEmpty)
        XCTAssertEqual(userLoginService.messages[0].userLoginPayload, userLoginPayload)
        XCTAssertTrue(userLogoutService.messages.isEmpty)
    }
    
    func test_sendNewUser_sendsNewUserMessage() {
        // given
        let newAccountService = NewAccountServiceSpy()
        let addNewUserService = AddNewUserServiceSpy()
        let userLoginService = UserLoginServiceSpy()
        let userLogoutService = UserLogoutServiceSpy()
        
        let newUserPayload = anyNewUserPayload()
        
        let sut = AuthService(
            newAccountService: newAccountService,
            addNewUserService: addNewUserService,
            userLoginService: userLoginService,
            userLogoutService: userLogoutService
        )
        
        // when
        sut.send(newUserPayload: newUserPayload) { _ in }
        
        // then
        XCTAssertTrue(newAccountService.messages.isEmpty)
        XCTAssertEqual(addNewUserService.messages[0].newUserPayload, newUserPayload)
        XCTAssertTrue(userLoginService.messages.isEmpty)
        XCTAssertTrue(userLogoutService.messages.isEmpty)
    }
    
    func test_sendUserLogout_sendsUserLogoutMessage() {
        // given
        let newAccountService = NewAccountServiceSpy()
        let addNewUserService = AddNewUserServiceSpy()
        let userLoginService = UserLoginServiceSpy()
        let userLogoutService = UserLogoutServiceSpy()
                
        let sut = AuthService(
            newAccountService: newAccountService,
            addNewUserService: addNewUserService,
            userLoginService: userLoginService,
            userLogoutService: userLogoutService
        )
        
        // when
        sut.logout { _ in }
        
        // then
        XCTAssertTrue(newAccountService.messages.isEmpty)
        XCTAssertTrue(addNewUserService.messages.isEmpty)
        XCTAssertTrue(userLoginService.messages.isEmpty)
        XCTAssertEqual(userLogoutService.messages.count, 1)
    }
    
    // MARK: - Helpers
    
    private func anyNewAccountPayload() -> NewAccountPayload {
        NewAccountPayload(email: "my@example.com", password: "123456")
    }
    
    private func anyUserLoginPayload() -> UserLoginPayload {
        UserLoginPayload(email: "my@example.com", password: "123456")
    }
    
    private func anyNewUserPayload() -> NewUserPayload {
        NewUserPayload(
            name: "user name",
            email: "user@example.com",
            avatarName: "avatar name",
            avatarColor: "avatar color")
    }
    
    private final class NewAccountServiceSpy: NewAccountServiceProtocol {
        private(set) var messages = [Message]()
        
        struct Message {
            let newAccountPayload: NewAccountPayload
            let completion: (Result<Void, Error>) -> Void
        }
        
        func send(
            newAccountPayload: NewAccountPayload,
            completion: @escaping (Result<Void, Error>) -> Void
        ) {
            messages.append(Message(newAccountPayload: newAccountPayload, completion: completion))
        }
    }
        
    private final class AddNewUserServiceSpy: AddNewUserServiceProtocol {
        private(set) var messages = [Message]()
        
        struct Message {
            let newUserPayload: NewUserPayload
            let completion: (Result<NewUserInfo, Error>) -> Void
        }
        
        func send(
            newUserPayload: NewUserPayload,
            completion: @escaping (Result<NewUserInfo, Error>) -> Void
        ) {
            messages.append(Message(newUserPayload: newUserPayload, completion: completion))
        }
    }
    
    private final class UserLoginServiceSpy: UserLoginServiceProtocol {
        private(set) var messages = [Message]()
        
        struct Message {
            let userLoginPayload: UserLoginPayload
            let completion: (Result<UserLoginInfo, Error>) -> Void
        }

        func send(
            userLoginPayload: UserLoginPayload,
            completion: @escaping (Result<UserLoginInfo, Error>) -> Void
        ) {
            messages.append(Message(userLoginPayload: userLoginPayload, completion: completion))
        }
    }
    
    private final class UserLogoutServiceSpy: UserLogoutServiceProtocol {
        private(set) var messages = [Message]()
        
        struct Message {
            let completion: (Result<Void, Error>) -> Void
        }

        func logout(completion: @escaping (Result<Void, Error>) -> Void) {
            messages.append(Message(completion: completion))
        }
    }
}
