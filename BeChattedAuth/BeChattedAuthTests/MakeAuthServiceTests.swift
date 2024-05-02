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
            authService().addUser(anyNewUserPayload(), authToken: "auth token") { _ in }
        })
    }
    
    func test_makeAuthService_setsCorrectUserLoginURL() {
        expect(userLoginURL(), when: {
            authService().login(anyUserLoginPayload()) { _ in }
        })
    }
    
    func test_makeAuthService_setsCorrectUserLogoutURL() {
        expect(userLogoutURL(), when: {
            authService().logout() { _ in }
        })
    }
    
    // MARK: - Helpers
    
    private func authService() -> AuthService {
        AuthService(configuration: authServiceConfiguration())
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
            userLogoutURL: userLogoutURL(),
            httpClient: FakeURLSessionHTTPClient()
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
    
    private final class FakeURLSessionHTTPClient: HTTPClientProtocol {
        private struct UnexpectedValuesRepresentation: Error {}
        
        private let session: URLSession
        
        public init(session: URLSession = .shared) {
            self.session = session
        }
        
        public func perform(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void) {
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data, let response = response as? HTTPURLResponse {
                    completion(.success((data, response)))
                } else {
                    completion(.failure(UnexpectedValuesRepresentation()))
                }
            }.resume()
        }
    }
}
