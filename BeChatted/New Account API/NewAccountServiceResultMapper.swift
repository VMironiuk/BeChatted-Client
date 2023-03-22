//
//  NewAccountServiceResultMapper.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 25.02.2023.
//

import Foundation


struct NewAccountServiceResultMapper {
    static func result(for response: HTTPURLResponse?) -> Result<Void, Error> {
        guard let response = response else { return .failure(NewAccountService.Error.unknown) }
        
        switch response.statusCode {
        case 200:
            return .success(())
        case 300:
            return .failure(NewAccountService.Error.email)
        case 500...599:
            return .failure(NewAccountService.Error.server)
        default:
            return .failure(NewAccountService.Error.unknown)
        }
    }
}
