//
//  ContentView.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = MazeViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.mazes) { maze in
                MazeRowView(maze: maze)
            }
            .navigationBarTitle("Maze Runner")
            .refreshable {
                await viewModel.fetchMazes()
            }
            .task {
                await viewModel.fetchMazes()
            }
        }
    }
}

#Preview {
    ContentView()
}
