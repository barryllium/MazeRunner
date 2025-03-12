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
        
        let ImageGrid = await imageProcessor.createGridFromImage(image)
        
        XCTAssertNotNil(ImageGrid)
        XCTAssertEqual(ImageGrid!.grid.count, 20)
        XCTAssertEqual(ImageGrid!.grid[0].count, 20)
        XCTAssertEqual(ImageGrid!.startPoint.x, 1)
        XCTAssertEqual(ImageGrid!.startPoint.y, 1)
        XCTAssertEqual(ImageGrid!.endPoint.x, 17)
        XCTAssertEqual(ImageGrid!.endPoint.y, 17)
    }
}

