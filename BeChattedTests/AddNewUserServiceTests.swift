//
//  AddNewUserServiceTests.swift
//  BeChattedTests
//
//  Created by Volodymyr Myroniuk on 28.03.2023.
//

import XCTest
import BeChatted

class AddNewUserService {
    private let url: URL
    private let client: HTTPClientProtocol
    
    enum AddNewUserError: Swift.Error {
        case connectivity
        case server
        case unknown
        case invalidData
    }
    
    typealias Error = AddNewUserError
    
    init(url: URL, client: HTTPClientProtocol) {
        self.url = url
        self.client = client
    }
    
    func send(newUserPayload: NewUserPayload, completion: @escaping (Result<NewUserInfo, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        client.perform(request: request) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                if response?.statusCode == 200 {
                    if let data = data, let newUser = try? JSONDecoder().decode(NewUserInfo.self, from: data) {
                        completion(.success(newUser))
                    } else {
                        completion(.failure(.invalidData))
                    }
                } else if response?.statusCode == 500 {
                    completion(.failure(.server))
                } else {
                    completion(.failure(.unknown))
                }
                break
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

final class AddNewUserServiceTests: XCTestCase {

    func test_init_doesNotSendNewUserPayloadByURL() {
        // given
        // when
        let (_, client) = makeSUT(url: anyURL())
        
        // then
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_send_sendNewUserPayloadByURL() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.send(newUserPayload: anyNewUserPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_send_sendsNewUserPayloadByURLTwice() {
        // given
        let url = anyURL()
        let (sut, client) = makeSUT(url: url)
        
        // when
        sut.send(newUserPayload: anyNewUserPayload()) { _ in }
        sut.send(newUserPayload: anyNewUserPayload()) { _ in }
        
        // then
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_send_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut: sut, toCompleteWithError: .connectivity, when: {
            client.complete(withError: anyNSError())
        })
    }
    
    func test_send_deliversServerErrorOn500HTTPResponse() {
        let (sut, client) = makeSUT()
        
        expect(sut: sut, toCompleteWithError: .server, when: {
            client.completeWith(response: httpResponse(withStatusCode: 500))
        })
    }
    
    func test_send_deliversUnknownErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [100, 199, 201, 300, 400, 599]
        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWithError: .unknown, when: {
                client.completeWith(response: httpResponse(withStatusCode: code), at: index)
            })
        }
    }
    
    func test_send_deliversInvalidDataErrorOn200HTTPResponseWithInvalidBody() {
        let (sut, client) = makeSUT()
        
        expect(sut: sut, toCompleteWithError: .invalidData, when: {
            client.completeWith(data: "any data".data(using: .utf8), response: httpResponse(withStatusCode: 200))
        })
    }
    
    func test_send_doesNotDeliverResultOnClientErrorAfterInstanceDeallocated() {
        let url = anyURL()
        let client = HTTPClientSpy()
        var sut: AddNewUserService? = AddNewUserService(url: url, client: client)
        
        expect(sut: &sut, doesNotDeliverResultWhen: {
            client.complete(withError: anyNSError())
        })
    }
    
    // 9. send() does not deliver result on 500 HTTP response after instance has been deallocated
    // 10. send() does not deliver result on non 200 HTTP response after instance has been deallocated
    // 11. send() does not deliver result on 200 HTTP response after instance has been deallocated
    // 12. send() delivers new user info on 200HTTP response with valid body
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (AddNewUserService, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = AddNewUserService(url: url, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(
        sut: AddNewUserService,
        toCompleteWithError expectedError: AddNewUserService.Error,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        let exp = expectation(description: "Wait for completion")
        var receivedError: AddNewUserService.Error?
        
        sut.send(newUserPayload: anyNewUserPayload()) { result in
            switch result {
            case let .failure(error):
                receivedError = error
                
            default:
                XCTFail("Expected failure, got \(result) instead.", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        // when
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        // then
        XCTAssertEqual(receivedError, expectedError, file: file, line: line)
    }
    
    private func expect(
        sut: inout AddNewUserService?,
        doesNotDeliverResultWhen action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // given
        var receivedResult: Result<NewUserInfo, AddNewUserService.Error>?
        
        sut?.send(newUserPayload: anyNewUserPayload()) { result in
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
    
    private func httpResponse(withStatusCode code: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
    
    private func anyNewUserPayload() -> NewUserPayload {
        NewUserPayload(
            name: "user name",
            email: "user@example.com",
            avatarName: "avatar name",
            avatarColor: "avatar color")
    }
    
    private class HTTPClientSpy: HTTPClientProtocol {
        private var messages = [Message]()
        
        var requestedURLs: [URL] {
            messages.compactMap { $0.request.url }
        }
        
        private struct Message {
            let request:  URLRequest
            let completion: (HTTPClientResult) -> Void
            
            init(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
                self.request = request
                self.completion = completion
            }
        }
        
        func perform(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append(Message(request: request, completion: completion))
        }
        
        func complete(withError error: Error, at index: Int = 0) {
            messages[0].completion(.failure(error))
        }
        
        func completeWith(data: Data? = nil, response: HTTPURLResponse, at index: Int = 0) {
            messages[index].completion(.success(data, response))
        }
    }
}
