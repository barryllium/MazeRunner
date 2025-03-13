//
//  ImageProcessor.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import UIKit

actor ImageProcessor {
    // MARK: - Image Grid Creation
    func createGridFromImage(_ image: UIImage) -> ImageGrid? {
        // Need to make sure we can create a cgImage from the uiImage
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let lowThreshold = 10
        let highThreshold = 245
        let imageSize = (width: cgImage.width, height: cgImage.height)
        var mazeArray = Array(repeating: Array(repeating: 1, count: imageSize.width), count: imageSize.height)
        var endPixels: [Point] = []
        var startPixels: [Point] = []
        
        // Check that we have all the pixel data we need from the image
        guard let data = cgImage.dataProvider?.data,
            let pixelData = CFDataGetBytePtr(data) else {
            return nil
        }
        
        // Each pixel has bytes for R,G,B,A
        let bytesPerPixel = 4
        
        // Traverse the image row by row
        for yIndex in 0..<imageSize.height {
            for xIndex in 0..<imageSize.width {
                let pixelIndex = (yIndex * imageSize.width + xIndex) * bytesPerPixel
                let colors: (red: UInt8, green: UInt8, blue: UInt8) = (pixelData[pixelIndex], pixelData[pixelIndex + 1], pixelData[pixelIndex + 2])
                
                // If black, set the entry in the array to 1, otherwise 0
                if colors.red < lowThreshold && colors.green < lowThreshold && colors.blue < lowThreshold {
                    mazeArray[yIndex][xIndex] = 1
                } else {
                    mazeArray[yIndex][xIndex] = 0
                    
                    // Collect all blue/start and red/end pixels
                    if colors.red < lowThreshold && colors.green < lowThreshold && colors.blue > highThreshold {
                        startPixels.append(Point(x: xIndex, y: yIndex))
                    } else if colors.red > highThreshold && colors.green < lowThreshold && colors.blue < lowThreshold {
                        endPixels.append(Point(x: xIndex, y: yIndex))
                    }
                }
            }
        }
        
        // Grab the center point of the start and end pixel sets
        guard let startPoint = selectCenterPoint(points: startPixels),
              let endPoint = selectCenterPoint(points: endPixels) else {
            return nil
        }
        
        return ImageGrid(grid: mazeArray, startPoint: startPoint, endPoint: endPoint)
    }
    
    private func selectCenterPoint(points: [Point]) -> Point? {
        guard !points.isEmpty else {
            return nil
        }
        
        // Get the middle pixel to start from and end at. This will add together
        // x and y values, and then divide by the number of points to find the
        // floor value of the average
        return Point(x: points.reduce(0, { $0 + $1.x }) / points.count,
                     y: points.reduce(0, { $0 + $1.y }) / points.count)
    }
    
    // MARK: - Path Finding
    func findPathFromImageGrid(_ imageGrid: ImageGrid) -> [Point]? {
        // Array of adjacent points from any point
        let directions = [Point(x: 0, y: 1),
                          Point(x: 1, y: 0),
                          Point(x: 0, y: -1),
                          Point(x: -1, y: 0)]
        
        // Create a pathQueue that keeps track of all current points to check
        var queue = [PathNode(point: imageGrid.startPoint,
                                  fullPath: [imageGrid.startPoint])]
        // Track all visited nodes so we don't double back
        var visitedNodes: Set<Point> = [imageGrid.startPoint]
        
        while !queue.isEmpty {
            // Grab the current node
            let currentNode = queue.removeFirst()
            
            // Check if the current point is the end point, if so, return the path
            if currentNode.point.x == imageGrid.endPoint.x,
               currentNode.point.y == imageGrid.endPoint.y {
                return currentNode.fullPath
            }
            
            // Check adjacent nodes
            for direction in directions {
                let adjacentNode = Point(x: currentNode.point.x + direction.x,
                                         y: currentNode.point.y + direction.y)
                
                /* Need to assure that the adjacent node has not previously
                 been checked, is within the bounds of the imageGrid, and
                 is not a wall */
                if !visitedNodes.contains(adjacentNode),
                   adjacentNode.x >= 0,
                   adjacentNode.y >= 0,
                   adjacentNode.x < imageGrid.grid[0].count,
                   adjacentNode.y < imageGrid.grid.count,
                   imageGrid.grid[adjacentNode.y][adjacentNode.x] == 0 {
                    visitedNodes.insert(adjacentNode)
                    queue.append(PathNode(point: adjacentNode,
                                              fullPath: currentNode.fullPath + [adjacentNode]))
                }
            }
        }
        
        // No solution was found, return nil
        return nil
    }
    
    // MARK: - Solved Image Generation
    func generateSolvedImage(from inputImage: UIImage, with path: [Point]) -> UIImage? {
        let imageRect = CGRect(x: 0, y: 0, width: inputImage.size.width, height: inputImage.size.height)
        
        // Check that all points exist within the image rect
        for point in path {
            if !imageRect.contains(CGPoint(x: point.x, y: point.y)) {
                return nil
            }
        }
        
        let imageRenderer = UIGraphicsImageRenderer(size: inputImage.size)
        let greenColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        
        // Draw the final image
        let finalImage = imageRenderer.image { context in
            // Set the original image as the base of the image
            inputImage.draw(in: imageRect)
            
            // Overlay a green pixel for every point in the path
            for point in path {
                let imagePoint = CGRect(x: point.x, y: point.y, width: 1, height: 1)
                greenColor.setFill()
                context.fill(imagePoint)
            }
        }
        
        return finalImage
    }
}
