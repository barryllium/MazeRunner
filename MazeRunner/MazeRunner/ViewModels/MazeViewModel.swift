//
//  MazeViewModel.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import Foundation
import UIKit

@Observable
class MazeViewModel {
    var apiClient: APIClientProtocol = APIClient.default
    
    var isLoading = false
    var mazes: [Maze] = []
    var selectedMaze: Maze?
    var solvedMazeImage: UIImage?
    
    var isShowingErrorAlert = false
    var imageLoadErrorMazeName: String? = nil
    
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
    
    func showErrorAlert(type: LoadError, mazeName: String? = nil) {
        imageLoadErrorMazeName = mazeName
        isShowingErrorAlert = true
    }
    
    func setSelectedMaze(_ maze: Maze) {
        solvedMazeImage = nil
        selectedMaze = maze
    }
}

enum LoadError {
    case loadMazesError
    case loadMazeImageError
}
