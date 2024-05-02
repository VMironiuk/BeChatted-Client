//
//  URLSessionHTTPClient.swift
//  BeChattedNetwork
//
//  Created by Volodymyr Myroniuk on 02.05.2024.
//

import Foundation

public final class URLSessionHTTPClient {
    private struct UnexpectedValuesRepresentation: Error {}
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func perform(request: URLRequest, completion: @escaping (Result<(Data?, HTTPURLResponse?), Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
}
