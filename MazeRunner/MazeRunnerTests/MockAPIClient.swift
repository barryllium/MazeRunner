//
//  MockAPIClient.swift
//  MazeRunnerTests
//
//  Created by Brett Keck on 3/12/25.
//

import Foundation
@testable import MazeRunner

final class MockAPIClient: APIClientProtocol {
    static var testDataString = "DataString"
    
    func fetchURL<T>(_ request: AsyncURLRequest<T>) async throws -> T where T : Decodable {
        let data = Bundle.main.decode(T.self, from: .mazes)
        return data 
    }
    
    func fetchData(_ url: URL) async throws -> Data {
        return Data(MockAPIClient.testDataString.utf8)
    }
}
