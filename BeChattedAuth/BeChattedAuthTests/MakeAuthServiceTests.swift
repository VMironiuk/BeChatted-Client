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
        let authServiceConfiguration = authServiceConfiguration()
        let authService = makeAuthService(configuration: authServiceConfiguration)
        let newAccountURL = newAccountURL()
        
        let exp = expectation(description: "Wait for request")
        URLProtocolStub.observeRequests { receivedRequest in
            XCTAssertEqual(receivedRequest.url, newAccountURL)
            exp.fulfill()
        }
        
        authService.send(newAccountPayload: anyNewAccountPayload()) { _ in }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
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
    
    private func anyNewAccountPayload() -> NewAccountPayload {
        NewAccountPayload(email: "my@example.com", password: "123456")
    }
    
    private class URLProtocolStub: URLProtocol {
        static private var stub: Stub?
        static private var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }
        
        override func startLoading() {
            if let requestObserver = Self.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                return requestObserver(request)
            }
            
            if let data = Self.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = Self.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = Self.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
