//
//  AuthServiceProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 30.10.2023.
//

import Foundation

public protocol AuthServiceProtocol:
    NewAccountServiceProtocol,
    UserLoginServiceProtocol,
    AddNewUserServiceProtocol,
    UserLogoutServiceProtocol
{
}
