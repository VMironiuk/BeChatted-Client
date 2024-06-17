//
//  AddUserResultMapper.swift
//  BeChattedAuth
//
//  Created by Volodymyr Myroniuk on 02.12.2023.
//

import Foundation

enum AddUserResultMapper {
    static func result(for result: Result<NewUserInfo, AddNewUserServiceError>) -> Result<NewUserInfo, AuthServiceError> {
        switch result {
        case .success(let newUserInfo):
            return .success(newUserInfo)
        case .failure(let error):
            return .failure(map(error: error))
        }
    }
    
    static private func map(error: AddNewUserServiceError) -> AuthServiceError {
        switch error {
        case .server:
            return .server
        case .connectivity:
            return .connectivity
        case .invalidData, .unknown:
            return .unknown
        }
    }
}
