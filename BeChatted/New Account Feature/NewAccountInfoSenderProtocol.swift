//
//  NewAccountInfoSenderProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 17.02.2023.
//

import Foundation

public protocol NewAccountInfoSenderProtocol {
    func send(newAccountInfo: NewAccountInfo, completion: @escaping (Result<Void, Error>) -> Void)
}
