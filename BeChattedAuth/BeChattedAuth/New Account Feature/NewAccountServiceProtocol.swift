//
//  NewAccountServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 17.02.2023.
//

import Foundation

enum NewAccountServiceError: Error {
    case connectivity
    case email
    case server
    case unknown
}

protocol NewAccountServiceProtocol {
    func send(newAccountPayload: NewAccountPayload, completion: @escaping (Result<Void, NewAccountServiceError>) -> Void)
}
