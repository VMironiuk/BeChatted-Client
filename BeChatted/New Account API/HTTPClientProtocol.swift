//
//  HTTPClientProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 24.02.2023.
//

import Foundation

public enum HTTPClientResult {
    case success(Data?, HTTPURLResponse?)
    case failure(Error?)
}

public protocol HTTPClientProtocol {
    func perform(request: URLRequest, completion: @escaping (HTTPClientResult) -> Void)
}
