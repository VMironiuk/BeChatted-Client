//
//  AuthServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 30.10.2023.
//

import XCTest
import BeChatted

final class AuthServiceTests: XCTestCase {
    private var sut: AuthServiceProtocol!
    private var newAccountService: NewAccountServiceSpy!
    private var addNewUserService: AddNewUserServiceSpy!
    private var userLoginService: UserLoginServiceSpy!
    private var userLogoutService: UserLogoutServiceSpy!
    
    override func setUp() {
        super.setUp()
        
        newAccountService = NewAccountServiceSpy()
        addNewUserService = AddNewUserServiceSpy()
        userLoginService = UserLoginServiceSpy()
        userLogoutService = UserLogoutServiceSpy()

        sut = AuthService(
            newAccountService: newAccountService,
            addNewUserService: addNewUserService,
            userLoginService: userLoginService,
            userLogoutService: userLogoutService
        )
    }
    
    func test_init_doesNotSendAnyMessages() {
        // given
        
        // when
        
        // then
        XCTAssertTrue(newAccountService.messages.isEmpty)
        XCTAssertTrue(addNewUserService.messages.isEmpty)
        XCTAssertTrue(userLoginService.messages.isEmpty)
        XCTAssertTrue(userLogoutService.messages.isEmpty)
    }
    
    func test_sendNewAccount_sendsNewAccountMessage() {
        // given
        let newAccountPayload = anyNewAccountPayload()
        
        // when
        sut.send(newAccountPayload: newAccountPayload) { _ in }
        
        // then
        XCTAssertEqual(newAccountService.messages[0].newAccountPayload, newAccountPayload)
        XCTAssertTrue(addNewUserService.messages.isEmpty)
        XCTAssertTrue(userLoginService.messages.isEmpty)
        XCTAssertTrue(userLogoutService.messages.isEmpty)
    }
    
    func test_sendNewAccount_completesWithSuccessOnNewAccountServiceSuccessfulCompletion() {
        // given
        let newAccountPayload = anyNewAccountPayload()
        let exp = expectation(description: "Wait for new account request completion")
        
        // when
        sut.send(newAccountPayload: newAccountPayload) { result in
            // then
            switch result {
            case .success:
                break
            default:
                XCTFail("Expected successful result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        newAccountService.complete(with: .success(()))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_sendNewAccount_completesWithFailureOnNewAccountServiceFailedCompletion() {
        // given
        let newAccountPayload = anyNewAccountPayload()
        let exp = expectation(description: "Wait for new account request completion")
        
        // when
        sut.send(newAccountPayload: newAccountPayload) { result in
            // then
            switch result {
            case .failure:
                break
            default:
                XCTFail("Expected failed result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        newAccountService.complete(with: .failure(anyNSError()))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_sendUserLogin_sendsUserLoginMessage() {
        // given
        let userLoginPayload = anyUserLoginPayload()
        
        // when
        sut.send(userLoginPayload: userLoginPayload) { _ in }
        
        // then
        XCTAssertTrue(newAccountService.messages.isEmpty)
        XCTAssertTrue(addNewUserService.messages.isEmpty)
        XCTAssertEqual(userLoginService.messages[0].userLoginPayload, userLoginPayload)
        XCTAssertTrue(userLogoutService.messages.isEmpty)
    }
    
    func test_sendUserLogin_completesWithSuccessOnUserLoginServiceSuccessfulCompletion() {
        // given
        let userLoginPayload = anyUserLoginPayload()
        let exp = expectation(description: "Wait for user login request completion")
        
        // when
        sut.send(userLoginPayload: userLoginPayload) { result in
            // then
            switch result {
            case .success:
                break
            default:
                XCTFail("Expected successful result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        userLoginService.complete(with: .success(anyUserLoginInfo()))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_sendUserLogin_completesWithFailureOnUserLoginServiceFailedCompletion() {
        // given
        let userLoginPayload = anyUserLoginPayload()
        let exp = expectation(description: "Wait for user login request completion")
        
        // when
        sut.send(userLoginPayload: userLoginPayload) { result in
            // then
            switch result {
            case .failure:
                break
            default:
                XCTFail("Expected failed result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        userLoginService.complete(with: .failure(anyNSError()))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_sendNewUser_sendsNewUserMessage() {
        // given
        let newUserPayload = anyNewUserPayload()
        
        // when
        sut.send(newUserPayload: newUserPayload) { _ in }
        
        // then
        XCTAssertTrue(newAccountService.messages.isEmpty)
        XCTAssertEqual(addNewUserService.messages[0].newUserPayload, newUserPayload)
        XCTAssertTrue(userLoginService.messages.isEmpty)
        XCTAssertTrue(userLogoutService.messages.isEmpty)
    }
    
    func test_sendNewUser_completesWithSuccessOnAddNewUserServiceSuccessfulCompletion() {
        // given
        let newUserPayload = anyNewUserPayload()
        let exp = expectation(description: "Wait for new user request completion")
        
        // when
        sut.send(newUserPayload: newUserPayload) { result in
            // then
            switch result {
            case .success:
                break
            default:
                XCTFail("Expected successful result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        addNewUserService.complete(with: .success(anyNewUserInfo()))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_sendNewUser_completesWithFailureOnAddNewUserServiceFailedCompletion() {
        // given
        let newUserPayload = anyNewUserPayload()
        let exp = expectation(description: "Wait for new user request completion")
        
        // when
        sut.send(newUserPayload: newUserPayload) { result in
            // then
            switch result {
            case .failure:
                break
            default:
                XCTFail("Expected successful result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        addNewUserService.complete(with: .failure(anyNSError()))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_sendUserLogout_sendsUserLogoutMessage() {
        // given
        
        // when
        sut.logout { _ in }
        
        // then
        XCTAssertTrue(newAccountService.messages.isEmpty)
        XCTAssertTrue(addNewUserService.messages.isEmpty)
        XCTAssertTrue(userLoginService.messages.isEmpty)
        XCTAssertEqual(userLogoutService.messages.count, 1)
    }
    
    func test_sendUserLogout_completesWithSuccessOnUserLogoutServiceSuccessfulCompletion() {
        // given
        let exp = expectation(description: "Wait for user logout request completion")
        
        // when
        sut.logout { result in
            // then
            switch result {
            case .success:
                break
            default:
                XCTFail("Expected successful result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        userLogoutService.complete(with: .success(()))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_sendUserLogout_completesWithFailureOnUserLogoutServiceFailedCompletion() {
        // given
        let exp = expectation(description: "Wait for user logout request completion")
        
        // when
        sut.logout { result in
            // then
            switch result {
            case .failure:
                break
            default:
                XCTFail("Expected successful result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        userLogoutService.complete(with: .failure(anyNSError()))
        
        wait(for: [exp], timeout: 1)
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
    
    private func anyNSError() -> Error {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyUserLoginInfo() -> UserLoginInfo {
        let jsonData = Data("{\"user\":\"a user\", \"token\":\"a token\"}".utf8)
        return try! JSONDecoder().decode(UserLoginInfo.self, from: jsonData)
    }
    
    private func anyNewUserInfo() -> NewUserInfo {
        let jsonData = Data("{\"name\":\"a name\", \"email\":\"mail@example.com\", \"avatarName\":\"\", \"avatarColor\":\"\"}".utf8)
        return try! JSONDecoder().decode(NewUserInfo.self, from: jsonData)
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
        
        func complete(with result: Result<Void, Error>, at index: Int = 0) {
            messages[index].completion(result)
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
        
        func complete(with result: Result<NewUserInfo, Error>, at index: Int = 0) {
            messages[index].completion(result)
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
        
        func complete(with result: Result<UserLoginInfo, Error>, at index: Int = 0) {
            messages[index].completion(result)
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
        
        func complete(with result: Result<Void, Error>, at index: Int = 0) {
            messages[index].completion(result)
        }
    }
}
