//
//  UserLoginServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 06.03.2023.
//

import XCTest
@testable import BeChattedAuth

final class UserLoginServiceTests: XCTestCase {
    
    func test_init_doesNotSendUserLoginRequestByURL() {
        // given
        let client = HTTPClientSpy()
        
        // when
        _ = UserLoginService(url: anyURL(), client: client)
        
        // then
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_send_sendsUserLoginRequestByURL() {
        // given
        let url = anyURL()
        let client = HTTPClientSpy()
        let sut = UserLoginService(url: url, client: client)
                
        // when
        sut.send(userLoginPayload: anyUserLoginPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_send_sendsUserLoginRequestByURLTwice() {
        // given
        let url = anyURL()
        let client = HTTPClientSpy()
        let sut = UserLoginService(url: url, client: client)
                
        // when
        sut.send(userLoginPayload: anyUserLoginPayload()) { _ in }
        sut.send(userLoginPayload: anyUserLoginPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_send_sendsUserLoginRequestAsPOSTMethod() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.send(userLoginPayload: anyUserLoginPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.httpMethods, ["POST"])
    }

    func test_send_sendsUserLoginRequestAsApplicationJSONContentType() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.send(userLoginPayload: anyUserLoginPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.contentTypes, ["application/json"])
    }

    func test_send_sendsUserLoginPayload() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        let userLoginPayload = UserLoginPayload(email: "user@example.com", password: "user password")
        
        // when
        sut.send(userLoginPayload: userLoginPayload) { _ in }
        
        // then
        XCTAssertEqual(client.userLoginPayloads, [userLoginPayload])
    }

    func test_send_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut: sut, toCompleteWithError: .connectivity, when: {
            client.complete(withError: anyNSError())
        })
    }
    
    func test_send_deliversInvalidCredentialsErrorOn401HTTPResponse() {
        let (sut, client) = makeSUT()

        expect(sut: sut, toCompleteWithError: .credentials, when: {
            client.complete(withHTTPResponse: httpResponse(withStatusCode: 401))
        })
    }
    
    func test_send_deliversServerErrorOn5xxHTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [500, 501, 502, 550, 580, 590, 599]
        
        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWithError: .server, when: {
                client.complete(withHTTPResponse: httpResponse(withStatusCode: code), at: index)
            })
        }
    }

    func test_send_deliversUnknownErrorOnNon200Or401Or5xxHTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 400, 402, 300, 309, 499]
        
        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWithError: .unknown, when: {
                client.complete(withHTTPResponse: httpResponse(withStatusCode: code), at: index)
            })
        }
    }

    func test_send_deliversInvalidDataErrorOn200HTTPResponseWithInvalidBody() {
        let (sut, client) = makeSUT()

        expect(sut: sut, toCompleteWithError: .invalidData, when: {
            client.complete(withHTTPResponse: httpResponse(withStatusCode: 200), data: anyData())
        })
    }

    func test_send_doesNotDeliverResultOnClientErrorAfterInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: UserLoginServiceProtocol? = UserLoginService(url: anyURL(), client: client)

        expect(sut: &sut, deliversNoResultWhen: {
            client.complete(withError: anyNSError())
        })
    }

    func test_send_doesNotDeliverResultOn401HTTPResponseAfterInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: UserLoginServiceProtocol? = UserLoginService(url: anyURL(), client: client)
        
        expect(sut: &sut, deliversNoResultWhen: {
            client.complete(withHTTPResponse: httpResponse(withStatusCode: 401))
        })
    }
    
    func test_send_doesNotDeliverResultOn500HTTPResponseAfterInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: UserLoginServiceProtocol? = UserLoginService(url: anyURL(), client: client)
        
        expect(sut: &sut, deliversNoResultWhen: {
            client.complete(withHTTPResponse: httpResponse(withStatusCode: 500))
        })
    }
    
    func test_send_doesNotDeliverResultOn200HTTPResponseAfterInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: UserLoginServiceProtocol? = UserLoginService(url: anyURL(), client: client)
        
        expect(sut: &sut, deliversNoResultWhen: {
            client.complete(withHTTPResponse: httpResponse(withStatusCode: 200))
        })
    }

    func test_send_deliversUserLoginInfoOn200HTTPResponse() {
        let expectedUserLoginInfoData = """
        {
            "user": "a user",
            "token": "auth token"
        }
        """.data(using: .utf8)
        let expectedUserLoginInfo = try! JSONDecoder().decode(UserLoginInfo.self, from: expectedUserLoginInfoData!)
        let (sut, client) = makeSUT()
        
        expect(sut: sut, toCompleteWithUserLoginInfo: expectedUserLoginInfo, when: {
            client.complete(withHTTPResponse: httpResponse(withStatusCode: 200), data: expectedUserLoginInfoData)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (UserLoginServiceProtocol, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = UserLoginService(url: url, client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(
        sut: UserLoginServiceProtocol,
        toCompleteWithError expectedError: UserLoginServiceError,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        let exp = expectation(description: "Wait for completion")
        var receivedError: UserLoginServiceError?
        sut.send(userLoginPayload: anyUserLoginPayload()) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected connectivity error, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        // when
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        // then
        XCTAssertEqual(receivedError, expectedError)
    }
    
    private func expect(
        sut: inout UserLoginServiceProtocol?,
        deliversNoResultWhen action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        var receivedResult: Result<UserLoginInfo, UserLoginServiceError>?
        sut?.send(userLoginPayload: anyUserLoginPayload()) { result in
            receivedResult = result
        }
        
        // when
        sut = nil
        
        action()
                
        // then
        XCTAssertNil(receivedResult, file: file, line: line)
    }
    
    private func expect(
        sut: UserLoginServiceProtocol,
        toCompleteWithUserLoginInfo expectedUserLoginInfo: UserLoginInfo,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        let exp = expectation(description: "Wait for completion")
        var receivedUserLoginInfo: UserLoginInfo?
        
        sut.send(userLoginPayload: anyUserLoginPayload()) { result in
            switch result {
            case let .success(userLoginInfo):
                receivedUserLoginInfo = userLoginInfo
            default:
                XCTFail("Expected success result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        // when
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        // then
        XCTAssertEqual(expectedUserLoginInfo, receivedUserLoginInfo)
    }
    
    private final class HTTPClientSpy: HTTPClientProtocol {
        private var messages = [Message]()
        
        private struct Message {
            let request: URLRequest
            let completion: (Result<(Data?, HTTPURLResponse?), Error>) -> Void
        }
        
        var requestedURLs: [URL] {
            messages.compactMap { $0.request.url }
        }
        
        var httpMethods: [String] {
            messages.compactMap { $0.request.httpMethod }
        }

        var contentTypes: [String] {
            messages.compactMap { $0.request.value(forHTTPHeaderField: "Content-Type") }
        }

        var userLoginPayloads: [UserLoginPayload] {
            messages.compactMap {
                guard let data = $0.request.httpBody else { return nil }
                return try? JSONDecoder().decode(UserLoginPayload.self, from: data)
            }
        }

        func perform(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void) {
            messages.append(Message(request: request, completion: completion))
        }
        
        func complete(withError error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withHTTPResponse httpResponse: HTTPURLResponse, data: Data? = nil, at index: Int = 0) {
            messages[index].completion(.success((data, httpResponse)))
        }
    }
}
