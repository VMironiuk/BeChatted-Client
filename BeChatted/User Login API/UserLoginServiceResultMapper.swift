//
//  UserLoginServiceResultMapper.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 22.03.2023.
//

import Foundation

struct UserLoginServiceResultMapper {
    static func result(for data: Data?, response: HTTPURLResponse?) -> Result<UserLoginInfo, Swift.Error> {
        guard let response = response else { return .failure(UserLoginService.Error.unknown) }
        
        switch response.statusCode {
        case 200:
            return result(for: data)
        case 401:
            return .failure(UserLoginService.Error.credentials)
        case 500...599:
            return .failure(UserLoginService.Error.server)
        default:
            return .failure(UserLoginService.Error.unknown)
        }
    }
    
    private static func result(for data: Data?) -> Result<UserLoginInfo, Swift.Error> {
        guard let data = data, let userInfo = try? JSONDecoder().decode(UserLoginInfo.self, from: data) else {
            return .failure(UserLoginService.Error.invalidData)
        }
        
        return .success(userInfo)
    }
}
