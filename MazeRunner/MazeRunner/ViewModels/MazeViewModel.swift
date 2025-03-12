//
//  MazeViewModel.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import Foundation

@Observable
class MazeViewModel {
    var apiClient: APIClientProtocol = APIClient.default
    
    var mazes: [Maze] = []
    
    func fetchMazes() async {
        guard let url = MazeList.fetchUrl else {
            return
        }
        
        let request = AsyncURLRequest<MazeList>(url: url)
        
        do {
            let result = try await apiClient.fetchURL(request)
            mazes = result.list
            for maze in mazes {
                await fetchMazeImage(maze: maze)
            }
        } catch {
            // TODO: Show error
        }
    }
    
    func fetchMazeImage(maze: Maze) async {
        guard let url = maze.url else {
            return
        }
        
        do {
            let data = try await apiClient.fetchData(url)
            if let index = mazes.firstIndex(where: { $0.id == maze.id }) {
                mazes[index].imageData = data
            }
        } catch {
            // TODO: Show error
        }
    }
}
