//
//  APIClient.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import Foundation

// Protocol that can be used to make unit testing simpler
protocol APIClientProtocol: Sendable {
    func fetchURL<T: Decodable>(_ request: AsyncURLRequest<T>) async throws -> T
    func fetchData(_ url: URL) async throws -> Data
}

final class APIClient: APIClientProtocol, Sendable {
    static let `default` = APIClient()
    
    func fetchURL<T: Decodable>(_ request: AsyncURLRequest<T>) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        
        if (response as? HTTPURLResponse)?.statusCode == 404 {
            throw NetworkError.notFound
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func fetchData(_ url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

// Wrapping the APIRequest in a generic struct to pass the decoding type as a phantom object
struct AsyncURLRequest<T> {
    let url: URL
    var urlRequest: URLRequest {
        URLRequest(url: url)
    }
}
