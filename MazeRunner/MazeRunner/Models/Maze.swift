//
//  Maze.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import Foundation

struct Maze: Codable {
    var name: String
    var description: String
    var urlString: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case urlString = "url"
    }
    
    var url: URL? {
        URL(string: urlString)
    }
}

struct MazeList: Codable {
    var list: [Maze]
    var count: Int
    
    static var fetchUrl: URL? {
        URL(string: "https://downloads-secured.bluebeam.com/homework/mazes")
    }
}
