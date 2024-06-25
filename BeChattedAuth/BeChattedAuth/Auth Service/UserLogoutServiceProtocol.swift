//
//  UserLogoutServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 07.04.2023.
//

import Foundation

protocol UserLogoutServiceProtocol {
  func logout(authToken: String, completion: @escaping (Result<Void, Error>) -> Void)
}
