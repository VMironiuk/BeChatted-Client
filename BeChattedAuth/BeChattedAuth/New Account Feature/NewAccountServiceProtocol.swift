//
//  NewAccountServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 17.02.2023.
//

import Foundation

protocol NewAccountServiceProtocol {
    func send(newAccountPayload: NewAccountPayload, completion: @escaping (Result<Void, Error>) -> Void)
}
