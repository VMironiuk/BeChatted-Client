//
//  UserLoginServiceResultMapper.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 22.03.2023.
//

import Foundation

enum UserLoginServiceResultMapper {
    static func result(for data: Data?, response: HTTPURLResponse?) -> Result<UserLoginInfo, UserLoginServiceError> {
        guard let response = response else { return .failure(.unknown) }
        
        switch response.statusCode {
        case 200:
            return result(for: data)
        case 401:
            return .failure(.credentials)
        case 500...599:
            return .failure(.server)
        default:
            return .failure(.unknown)
        }
    }
    
    private static func result(for data: Data?) -> Result<UserLoginInfo, UserLoginServiceError> {
        guard let data = data, let userInfo = try? JSONDecoder().decode(UserLoginInfo.self, from: data) else {
            return .failure(.invalidData)
        }
        
        return .success(userInfo)
    }
}
