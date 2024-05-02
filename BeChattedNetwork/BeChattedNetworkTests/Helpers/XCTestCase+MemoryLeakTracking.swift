//
//  XCTestCase+MemoryLeakTracking.swift
//  BeChattedNetworkTests
//
//  Created by Volodymyr Myroniuk on 02.05.2024.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(
        _ object: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(
                object,
                "Expected object to be nil. Potential memory leak",
                file: file,
                line: line
            )
        }
    }
}
