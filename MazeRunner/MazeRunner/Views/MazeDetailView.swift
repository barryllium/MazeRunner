//
//  MazeDetailView.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import SwiftUI

struct MazeDetailView: View {
    @Bindable var mazeViewModel: MazeViewModel
    
    var body: some View {
        Text(mazeViewModel.selectedMaze?.name ?? "No Maze Selected")
    }
}

#Preview {
    MazeDetailView(mazeViewModel: MazeViewModel())
}
