//
//  UserLogoutServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 07.04.2023.
//

import Foundation

public protocol UserLogoutServiceProtocol {
    func logout(completion: (Result<Void, Error>) -> Void)
}
