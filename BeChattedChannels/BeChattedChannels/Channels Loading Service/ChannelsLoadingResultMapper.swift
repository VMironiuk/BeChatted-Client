//
//  ChannelsLoadingResultMapper.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 09.04.2024.
//

import Foundation

enum ChannelsLoadingResultMapper {
    static func result(for data: Data?, response: HTTPURLResponse?) -> Result<[ChannelInfo], ChannelsLoadingError> {
        guard let response = response else { return .failure(.unknown) }
        
        switch response.statusCode {
        case 200:
            return result(for: data)
        default:
            return .failure(.server)
        }
    }
    
    private static func result(for data: Data?) -> Result<[ChannelInfo], ChannelsLoadingError> {
        guard let data = data, let channels = try? JSONDecoder().decode([ChannelInfo].self, from: data) else {
            return .failure(.invalidData)
        }
        
        return .success(channels)
    }
}
