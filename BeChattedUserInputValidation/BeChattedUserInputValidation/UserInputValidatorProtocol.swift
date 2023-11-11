//
//  UserInputValidatorProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 02.06.2023.
//

import Foundation

public protocol UserInputValidatorProtocol {
    func isValid(_ input: String) -> Bool
}
