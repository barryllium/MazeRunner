//
//  ImageProcessor.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import UIKit

actor ImageProcessor {
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
}
