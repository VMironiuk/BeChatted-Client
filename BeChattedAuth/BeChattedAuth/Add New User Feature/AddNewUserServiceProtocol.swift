//
//  AddNewUserServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 31.03.2023.
//

import Foundation

protocol AddNewUserServiceProtocol {
    func send(newUserPayload: NewUserPayload, authToken: String, completion: @escaping (Result<NewUserInfo, Error>) -> Void)
}
