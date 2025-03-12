//
//  NetworkError.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case notFound
    case other
}

extension LocalizedError {
    var errorDescription: String? {
        return "\(self)"
    }
}
