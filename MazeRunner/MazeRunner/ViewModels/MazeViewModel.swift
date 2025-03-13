//
//  MazeViewModel.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import Foundation
import UIKit

@MainActor
@Observable
class MazeViewModel {
    var apiClient: APIClientProtocol = APIClient.default
    var imageProcessor = ImageProcessor()
    
    var isLoading = false
    var mazes: [Maze] = []
    var selectedMaze: Maze?
    
    var isShowingErrorAlert = false
    var imageLoadErrorMazeName: String? = nil
    
    var imageGenerationStep: ImageGenerationStep = .initializing
    var solvedMazeImage: UIImage?
    
    func setSelectedMaze(_ maze: Maze) {
        solvedMazeImage = nil
        selectedMaze = maze
        imageGenerationStep = .initializing
    }
    
    private var imageProcessingTask: Task<UIImage?, Never>?
    
    // MARK: - Fetch network data
    func fetchMazes() async {
        guard let url = MazeList.fetchUrl else {
            return
        }
        
        isLoading = true
        
        defer { isLoading = false }
        
        let request = AsyncURLRequest<MazeList>(url: url)
        
        do {
            let result = try await apiClient.fetchURL(request)
            mazes = result.list
            for maze in mazes {
                await fetchMazeImage(maze: maze)
            }
        } catch {
            showErrorAlert(type: .loadMazesError)
        }
    }
    
    func fetchMazeImage(maze: Maze) async {
        guard let url = maze.url else {
            showErrorAlert(type: .loadMazeImageError, mazeName: maze.name)
            return
        }
        
        do {
            let data = try await apiClient.fetchData(url)
            if let index = mazes.firstIndex(where: { $0.id == maze.id }) {
                mazes[index].imageData = data
            }
        } catch {
            showErrorAlert(type: .loadMazeImageError, mazeName: maze.name)
        }
    }
    
    // MARK: - Error messaging
    func showErrorAlert(type: LoadError, mazeName: String? = nil) {
        imageLoadErrorMazeName = mazeName
        isShowingErrorAlert = true
    }
    
    // MARK: - Maze Solving
    func solveMaze() async {
        imageProcessingTask?.cancel()
        
        imageProcessingTask = Task {
            imageGenerationStep = .generatingImageGrid
            guard let imageGrid = await createImageGrid() else {
                if Task.isCancelled { return nil }
                
                imageGenerationStep = .errored(error: "image_grid_failed")
                return nil
            }
            
            if !Task.isCancelled {
                imageGenerationStep = .pathFinding
                guard let path = await findMazePath(imageGrid: imageGrid) else {
                    if Task.isCancelled { return nil }
                    
                    imageGenerationStep = .errored(error: "path_finding_failed")
                    return nil
                }
                
                if !Task.isCancelled {
                    imageGenerationStep = .generatingImage
                    guard let finalImage = await generateSolvedImage(path: path) else {
                        if Task.isCancelled { return nil }
                        
                        imageGenerationStep = .errored(error: "image_generation_failed")
                        return nil
                    }
                    
                    return finalImage
                }
            }
            
            return nil
        }
        
        if let finalImage = await imageProcessingTask?.value {
            solvedMazeImage = finalImage
            imageGenerationStep = .complete
        }
    }
    
    private func createImageGrid() async -> ImageGrid? {
        guard let image = selectedMaze?.image else {
            return nil
        }
        
        return await imageProcessor.createGridFromImage(image)
    }
    
    private func findMazePath(imageGrid: ImageGrid) async -> [Point]? {
        return await imageProcessor.findPathFromImageGrid(imageGrid)
    }
    
    private func generateSolvedImage(path: [Point]) async -> UIImage? {
        guard let image = selectedMaze?.image else {
            return nil
        }
        
        return await imageProcessor.generateSolvedImage(from: image, with: path)
    }
}

enum LoadError {
    case loadMazesError
    case loadMazeImageError
}
