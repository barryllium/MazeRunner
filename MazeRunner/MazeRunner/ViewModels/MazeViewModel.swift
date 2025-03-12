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
        } catch {
            // TODO: Show error
        }
    }
}
