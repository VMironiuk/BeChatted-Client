//
//  URLSessionHTTPClientTests.swift
//  BeChattedNetworkTests
//
//  Created by Volodymyr Myroniuk on 02.05.2024.
//

import XCTest
import BeChattedNetwork

final class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_performRequest_performsCorrectRequest() {
        let expectedRequest = URLRequest(url: anyURL())
        
        let exp = expectation(description: "Wait for request")
        URLProtocolStub.observeRequests { receivedRequest in
            XCTAssertEqual(receivedRequest, expectedRequest)
            exp.fulfill()
        }
        
        makeSUT().perform(request: expectedRequest) { _ in }
        wait(for: [exp], timeout: 1.0)
    }

    func test_performRequest_failsOnRequestError() {
        let requestError = anyNSError() as NSError
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)
                
        XCTAssertEqual((receivedError as? NSError)?.domain, requestError.domain)
        XCTAssertEqual((receivedError as? NSError)?.code, requestError.code)
    }
    
    func test_performRequest_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }
    
    func test_performRequest_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor(data: data, response: response, error: nil)

        XCTAssertEqual(receivedValues.data, data)
        XCTAssertEqual(receivedValues.response?.url, response.url)
        XCTAssertEqual(receivedValues.response?.statusCode, response.statusCode)
    }
    
    func test_performRequest_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor(data: nil, response: response, error: nil)
        
        let emptyData = Data()
        XCTAssertEqual(receivedValues.data, emptyData)
        XCTAssertEqual(receivedValues.response?.url, response.url)
        XCTAssertEqual(receivedValues.response?.statusCode, response.statusCode)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        return sut
    }
    
    private func resultErrorFor(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Error? {
        let receivedResult = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        switch receivedResult {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(receivedResult) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultValuesFor(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (data: Data?, response: HTTPURLResponse?) {
        let receivedResult = resultFor(data: data, response: response, error: error, file: file, line: line)
        
        switch receivedResult {
        case let .success((data, response)):
            return (data, response)
        default:
            XCTFail("Expected success, got \(receivedResult) instead", file: file, line: line)
            return (nil, nil)
        }
    }
    
    private func resultFor(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (Result<(Data?, HTTPURLResponse?), Error>) {
        let request = URLRequest(url: anyURL())
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: (Result<(Data?, HTTPURLResponse?), Error>)!
        sut.perform(request: request) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        return receivedResult
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
}
