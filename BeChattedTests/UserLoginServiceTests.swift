//
//  UserLoginServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 06.03.2023.
//

import XCTest
import BeChatted

protocol HTTPClient {
    func perform(request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}

final class UserLoginService {
    private let url: URL
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case connectivity
        case credentials
        case server
        case invalidData
        case unknown
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func send(userLoginPayload: UserLoginPayload, completion: @escaping (Result<UserLoginInfo, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(userLoginPayload)
        
        client.perform(request: request) { [weak self] data, response, error in
            guard self != nil else { return }
            if error != nil {
                completion(.failure(.connectivity))
            } else if let response = response {
                if response.statusCode == 200 {
                    if let data = data, let userInfo = try? JSONDecoder().decode(UserLoginInfo.self, from: data) {
                        completion(.success(userInfo))
                    } else {
                        completion(.failure(.invalidData))
                    }
                } else if response.statusCode == 401 {
                    completion(.failure(.credentials))
                } else if (500...599).contains(response.statusCode) {
                    completion(.failure(.server))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }
    }
}

final class UserLoginServiceTests: XCTestCase {
    
    func test_init_doesNotSendUserLoginPayloadByURL() {
        // given
        let client = HTTPClientSpy()
        
        // when
        _ = UserLoginService(url: anyURL(), client: client)
        
        // then
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_send_sendsUserLoginPayloadByURL() {
        // given
        let url = anyURL()
        let client = HTTPClientSpy()
        let sut = UserLoginService(url: url, client: client)
                
        // when
        sut.send(userLoginPayload: anyUserLoginPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_send_sendsUserLoginPayloadByURLTwice() {
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

    func test_send_doesNotDeliverConnectivityErrorOnClientErrorAfterInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: UserLoginService? = UserLoginService(url: anyURL(), client: client)

        expect(sut: &sut, deliversNoResultWhen: {
            client.complete(withError: anyNSError())
        })
    }

    // 10. send() does not deliver error on non 200 HTTP response after instance has been deallocated
    // 11. send() does not deliver user(name) and token on 200 HTTP response after instance has been deallocated
    // 12. send() delivers user(name) and token on 200 HTTP response
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (UserLoginService, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = UserLoginService(url: url, client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(
        sut: UserLoginService,
        toCompleteWithError expectedError: UserLoginService.Error,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        let exp = expectation(description: "Wait for completion")
        var receivedError: UserLoginService.Error?
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
        sut: inout UserLoginService?,
        deliversNoResultWhen action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        var receivedResult: Result<UserLoginInfo, UserLoginService.Error>?
        sut?.send(userLoginPayload: anyUserLoginPayload()) { result in
            receivedResult = result
        }
        
        // when
        sut = nil
        
        action()
                
        // then
        XCTAssertNil(receivedResult, file: file, line: line)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private func anyUserLoginPayload() -> UserLoginPayload {
        UserLoginPayload(email: "my@example.com", password: "123456")
    }
    
    private func anyData() -> Data {
        Data("any data".utf8)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func httpResponse(withStatusCode statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    private final class HTTPClientSpy: HTTPClient {
        private var messages = [Message]()
        
        private struct Message {
            let url: URL
            let completion: (Data?, HTTPURLResponse?, Error?) -> Void
        }
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func perform(request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
            if let requestedUrl = request.url {
                messages.append(Message(url: requestedUrl, completion: completion))
            }
        }
        
        func complete(withError error: Error, at index: Int = 0) {
            messages[index].completion(nil, nil, error)
        }
        
        func complete(withHTTPResponse httpResponse: HTTPURLResponse, data: Data? = nil, at index: Int = 0) {
            messages[index].completion(data, httpResponse, nil)
        }
    }
}
