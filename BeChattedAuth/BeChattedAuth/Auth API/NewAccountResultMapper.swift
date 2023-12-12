//
//  NewAccountResultMapper.swift
//  BeChattedAuth
//
//  Created by Volodymyr Myroniuk on 02.12.2023.
//

import Foundation

struct NewAccountResultMapper {
    private init() {}
    
    static func result(for result: Result<Void, NewAccountServiceError>) -> Result<Void, AuthServiceError> {
        switch result {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(map(error: error))
        }
    }
    
    static private func map(error: NewAccountServiceError) -> AuthServiceError {
        switch error {
        case .server:
            return .server
        case .connectivity:
            return .connectivity
        case .email:
            return .email
        case .unknown:
            return .unknown
        }
    }
}
