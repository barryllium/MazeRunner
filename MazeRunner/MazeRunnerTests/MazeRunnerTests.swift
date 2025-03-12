//
//  MazeRunnerTests.swift
//  MazeRunnerTests
//
//  Created by Brett Keck on 3/12/25.
//

import XCTest
@testable import MazeRunner

final class MazeRunnerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidMazeUrl() {
        let data = Bundle.main.decode(MazeList.self, from: .mazes)
        let mazes = try? JSONDecoder().decode(MazeList.self, from: JSONEncoder().encode(data))
        
        XCTAssertNotNil(mazes)
        XCTAssertNotNil(mazes!.list[0].url)
        XCTAssertEqual(mazes!.list[0].url?.absoluteString, "https://downloads-secured.bluebeam.com/homework/maze1.png")
    }
    
    func testInvalidMazeUrl() {
        let data = Bundle.main.decode(MazeList.self, from: .mazes)
        let mazes = try? JSONDecoder().decode(MazeList.self, from: JSONEncoder().encode(data))
        
        XCTAssertNotNil(mazes)
        var maze = mazes!.list[0]
        maze.urlString = ""
        XCTAssertNil(maze.url)
    }
}
