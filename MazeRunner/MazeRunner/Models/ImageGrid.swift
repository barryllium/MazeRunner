//
//  ImageGrid.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import Foundation

struct ImageGrid: Codable {
    let grid: [[Int]]
    let startPoint: Point
    let endPoint: Point
}
