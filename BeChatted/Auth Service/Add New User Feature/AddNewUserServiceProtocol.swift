//
//  AddNewUserServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.03.2023.
//

import Foundation

public protocol AddNewUserServiceProtocol {
    func send(newUserPayload: NewUserPayload, completion: @escaping (Result<NewUserInfo, Error>) -> Void)
}
