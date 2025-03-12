//
//  Maze.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import Foundation
import UIKit

struct Maze: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var description: String
    var urlString: String
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case urlString = "url"
    }
    
    var url: URL? {
        URL(string: urlString)
    }
    
    var image: UIImage? {
        if let imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}

struct MazeList: Codable {
    var list: [Maze]
    var count: Int
    
    static var fetchUrl: URL? {
        URL(string: "https://downloads-secured.bluebeam.com/homework/mazes")
    }
}
