//
//  AddNewUserServiceResultMapper.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 05.04.2023.
//

import Foundation

struct AddNewUserServiceResultMapper {
    private init() {}
    
    static func result(for data: Data?, response: HTTPURLResponse?) -> Result<NewUserInfo, AddNewUserServiceError> {
        guard let response = response else { return .failure(.unknown) }
        
        switch response.statusCode {
        case 200:
            return result(for: data)
        case 500:
            return .failure(.server)
        default:
            return .failure(.unknown)
        }
    }
    
    private static func result(for data: Data?) -> Result<NewUserInfo, AddNewUserServiceError> {
        guard let data = data, let newUserInfo = try? JSONDecoder().decode(NewUserInfo.self, from: data) else {
            return .failure(.invalidData)
        }
        
        return .success(newUserInfo)
    }
}
