//
//  AddNewUserServiceResultMapper.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.04.2023.
//

import Foundation

struct AddNewUserServiceResultMapper {
    static func result(for data: Data?, response: HTTPURLResponse?) -> Result<NewUserInfo, Swift.Error> {
        guard let response = response else { return .failure(AddNewUserService.Error.unknown) }
        
        switch response.statusCode {
        case 200:
            return result(for: data)
        case 500:
            return .failure(AddNewUserService.Error.server)
        default:
            return .failure(AddNewUserService.Error.unknown)
        }
    }
    
    private static func result(for data: Data?) -> Result<NewUserInfo, Swift.Error> {
        guard let data = data, let newUserInfo = try? JSONDecoder().decode(NewUserInfo.self, from: data) else {
            return .failure(AddNewUserService.Error.invalidData)
        }
        
        return .success(newUserInfo)
    }
}
