//
//  NewAccountInfoSenderProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 17.02.2023.
//

import Foundation

protocol NewAccountInfoSenderProtocol {
    func send(_ info: NewAccountInfo, completion: @escaping (Result<Void, Error>) -> Void)
}
