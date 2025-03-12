//
//  MazeRunnerTests.swift
//  MazeRunnerTests
//
//  Created by Brett Keck on 3/12/25.
//

import XCTest
@testable import MazeRunner

final class MazeRunnerTests: XCTestCase {
    var viewModel: MazeViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        
        viewModel = MazeViewModel()
        viewModel.apiClient = MockAPIClient()
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
    
    func testFetchMazeData() async {
        await viewModel.fetchMazes()
        
        XCTAssertEqual(viewModel.mazes.count, 3)
        XCTAssertEqual(viewModel.mazes[0].name, "Maze 1")
        XCTAssertEqual(viewModel.mazes[0].description, "Simple square maze")
        XCTAssertEqual(viewModel.mazes[0].urlString, "https://downloads-secured.bluebeam.com/homework/maze1.png")
    }
}
