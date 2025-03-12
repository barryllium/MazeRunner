//
//  ContentView.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var mazeViewModel = MazeViewModel()
    @State private var navigationPath: [Maze] = []
    
    @State private var isShowingLoadError = false
    @State private var imageLoadErrorMazeName: String = ""
    @State private var isShowingImageLoadError = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List(mazeViewModel.mazes) { maze in
                Button {
                    mazeViewModel.selectedMaze = maze
                    navigationPath.append(maze)
                } label: {
                    MazeRowView(maze: maze)
                }
            }
            .navigationBarTitle("maze_runner")
            .navigationDestination(for: Maze.self, destination: { _ in
                MazeDetailView(mazeViewModel: mazeViewModel)
            })
            .refreshable {
                await mazeViewModel.fetchMazes()
            }
            .task {
                await mazeViewModel.fetchMazes()
            }
            .alert(isPresented: $mazeViewModel.isShowingErrorAlert) {
                Alert(title: Text("error"),
                      message: Text(mazeViewModel.imageLoadErrorMazeName == nil ? "load_error_description" : "image_error_description \(mazeViewModel.imageLoadErrorMazeName ?? "")"),
                      dismissButton: .default(Text("ok")))
            }
        }
    }
}

#Preview {
    ContentView()
}
