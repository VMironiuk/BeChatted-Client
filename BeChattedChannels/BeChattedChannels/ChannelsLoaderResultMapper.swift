//
//  ChannelsLoaderResultMapper.swift
//  BeChattedChannels
//
//  Created by Volodymyr Myroniuk on 09.04.2024.
//

import Foundation

struct ChannelsLoaderResultMapper {
    static func result(for data: Data?, response: HTTPURLResponse?) -> Result<[ChannelInfo], Error> {
        guard let response = response else { return .failure(ChannelsLoaderError.unknown) }
        
        switch response.statusCode {
        case 200:
            return result(for: data)
        default:
            return .failure(ChannelsLoaderError.server)
        }
    }
    
    private static func result(for data: Data?) -> Result<[ChannelInfo], Error> {
        guard let data = data, let channels = try? JSONDecoder().decode([ChannelInfo].self, from: data) else {
            return .failure(ChannelsLoaderError.invalidData)
        }
        
        return .success(channels)
    }
}
