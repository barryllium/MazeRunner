//
//  ContentView.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(NetworkViewModel.self) var networkViewModel: NetworkViewModel
    @State private var mazeViewModel = MazeViewModel()
    @State private var navigationPath: [Maze] = []
    
    @State private var isShowingLoadError = false
    @State private var imageLoadErrorMazeName: String = ""
    @State private var isShowingImageLoadError = false
    
    var body: some View {
        VStack(spacing: 0) {
            if !networkViewModel.isConnected {
                NoNetworkView()
            }
            
            NavigationStack(path: $navigationPath) {
                List(mazeViewModel.mazes) { maze in
                    Button {
                        mazeViewModel.selectedMaze = maze
                        navigationPath.append(maze)
                    } label: {
                        MazeRowView(maze: maze)
                    }
                    .buttonStyle(.plain)
                }
                .navigationBarTitle("maze_runner")
                .navigationDestination(for: Maze.self, destination: { _ in
                    MazeDetailView(mazeViewModel: mazeViewModel)
                })
                .refreshable {
                    if networkViewModel.isConnected {
                        await mazeViewModel.fetchMazes()
                    }
                }
                .task {
                    await mazeViewModel.fetchMazes()
                }
                .onChange(of: networkViewModel.isConnected, { _, newValue in
                    if newValue {
                        Task {
                            await mazeViewModel.fetchMazes()
                        }
                    }
                })
                .alert(isPresented: $mazeViewModel.isShowingErrorAlert) {
                    Alert(title: Text("error"),
                          message: Text(mazeViewModel.imageLoadErrorMazeName == nil ? "load_error_description" : "image_error_description \(mazeViewModel.imageLoadErrorMazeName ?? "")"),
                          dismissButton: .default(Text("ok")))
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(NetworkViewModel())
}
