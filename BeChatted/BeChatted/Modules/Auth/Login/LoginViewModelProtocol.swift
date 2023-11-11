//
//  LoginViewModelProtocol.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 11.11.2023.
//

import Foundation

public protocol LoginViewModelProtocol: AnyObject, ObservableObject {
    var email: String { get set }
    var password: String { get set }
    var isUserInputValid: Bool { get }
}
