//
//  MakeAuthServiceTests.swift
//  BeChattedAuthTests
//
//  Created by Volodymyr Myroniuk on 01.11.2023.
//

import XCTest
import BeChattedAuth

final class MakeAuthServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_makeAuthService_setsCorrectNewAccountURL() {
        expect(newAccountURL(), when: {
            authService().createAccount(anyNewAccountPayload()) { _ in }
        })
    }
    
    func test_makeAuthService_setsCorrectNewUserURL() {
        expect(newUserURL(), when: {
            authService().send(newUserPayload: anyNewUserPayload()) { _ in }
        })
    }
    
    func test_makeAuthService_setsCorrectUserLoginURL() {
        expect(userLoginURL(), when: {
            authService().send(userLoginPayload: anyUserLoginPayload()) { _ in }
        })
    }
    
    func test_makeAuthService_setsCorrectUserLogoutURL() {
        expect(userLogoutURL(), when: {
            authService().logout() { _ in }
        })
    }
    
    // MARK: - Helpers
    
    
    private func authService() -> AuthServiceProtocol {
        makeAuthService(configuration: authServiceConfiguration())
    }
    
    private func expect(_ expectedURL: URL, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        // given
        
        let exp = expectation(description: "Wait for request")
        URLProtocolStub.observeRequests { receivedRequest in
            // then
            XCTAssertEqual(receivedRequest.url, expectedURL)
            exp.fulfill()
        }
        
        // when
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func authServiceConfiguration() -> AuthServiceConfiguration {
        AuthServiceConfiguration(
            newAccountURL: newAccountURL(),
            newUserURL: newUserURL(),
            userLoginURL: userLoginURL(),
            userLogoutURL: userLogoutURL()
        )
    }
    
    private func newAccountURL() -> URL {
        URL(string: "http://new-account.com")!
    }
    
    private func newUserURL() -> URL {
        URL(string: "http://new-user.com")!
    }
    
    private func userLoginURL() -> URL {
        URL(string: "http://user-login.com")!
    }
    
    private func userLogoutURL() -> URL {
        URL(string: "http://user-logout.com")!
    }
}
