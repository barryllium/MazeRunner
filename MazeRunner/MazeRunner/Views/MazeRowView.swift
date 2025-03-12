//
//  MazeRowView.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import SwiftUI

struct MazeRowView: View {
    var maze: Maze
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(maze.name)
                .font(.body)
                .fontWeight(.bold)
            Text(maze.description)
                .font(.subheadline)
            
            if let image = maze.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .leading)
            }
        }
    }
}

#Preview {
    MazeRowView(maze: Maze(name: "Test Maze",
                           description: "Just a description",
                           urlString: "https://downloads-secured.bluebeam.com/homework/maze1.png"))
}
