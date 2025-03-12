//
//  ImageProcessingTests.swift
//  MazeRunnerTests
//
//  Created by Brett Keck on 3/12/25.
//

import XCTest
@testable import MazeRunner

final class ImageProcessingTests: XCTestCase {
    let imageProcessor = ImageProcessor()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGridFromImage() async {
        let image = UIImage(named: "testMaze")!
        
        let imageGrid = await imageProcessor.createGridFromImage(image)
        
        XCTAssertNotNil(imageGrid)
        XCTAssertEqual(imageGrid!.grid.count, 20)
        XCTAssertEqual(imageGrid!.grid[0].count, 20)
        XCTAssertEqual(imageGrid!.startPoint.x, 1)
        XCTAssertEqual(imageGrid!.startPoint.y, 1)
        XCTAssertEqual(imageGrid!.endPoint.x, 17)
        XCTAssertEqual(imageGrid!.endPoint.y, 17)
    }
    
    func testGridShouldFailNoStartPoints() async {
        let image = UIImage(named: "testMazeNoStart")!
        
        let imageGrid = await imageProcessor.createGridFromImage(image)
        
        XCTAssertNil(imageGrid)
    }
    
    func testGridShouldFailNoEndPoints() async {
        let image = UIImage(named: "testMazeNoEnd")!
        
        let imageGrid = await imageProcessor.createGridFromImage(image)
        
        XCTAssertNil(imageGrid)
    }
    
    func testPathFindingFromGrid() async {
        let imageGrid = Bundle.main.decode(ImageGrid.self, from: .grid)
        
        let path = await imageProcessor.findPathFromImageGrid(imageGrid)
        
        XCTAssertNotNil(path)
        XCTAssertEqual(path!.count, 89)
        XCTAssertEqual(path![0].x, imageGrid.startPoint.x)
        XCTAssertEqual(path![0].y, imageGrid.startPoint.y)
        XCTAssertEqual(path![88].x, imageGrid.endPoint.x)
        XCTAssertEqual(path![88].y, imageGrid.endPoint.y)
    }
    
    func testPathFindingFromGridWithBadEndNodeShouldFail() async {
        let imageGrid = Bundle.main.decode(ImageGrid.self, from: .grid)
        let updatedImageGrid = ImageGrid(grid: imageGrid.grid,
                                         startPoint: imageGrid.startPoint,
                                         endPoint: Point(x: 19, y: 19))
        
        let path = await imageProcessor.findPathFromImageGrid(updatedImageGrid)
        
        XCTAssertNil(path)
    }
}

